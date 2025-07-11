import 'package:dio/dio.dart';
import 'package:yandex_school_homework/app/http/i_http_client.dart';
import 'package:yandex_school_homework/app/database/i_database_service.dart';
import 'package:yandex_school_homework/features/transactions/data/dto/transaction_response/transaction_response_dto.dart';
import 'package:yandex_school_homework/features/transactions/domain/repository/i_transactions_repository.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_request_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';
import 'package:yandex_school_homework/features/transactions/data/dto/transaction_request/transaction_request_dto_mapper.dart';
import 'package:yandex_school_homework/features/transactions/data/dto/transaction_response/transaction_response_dto_mapper.dart';

final class TransactionsBackupRepository implements ITransactionsRepository {
  TransactionsBackupRepository({
    required this.httpClient,
    required this.databaseService,
  });

  final IHttpClient httpClient;
  final IDatabaseService databaseService;

  @override
  String get name => 'TransactionsBackupRepository';

  static const String transactionsEndpoint = 'transactions';

  @override
  Future<List<TransactionResponseEntity>> fetchTransactionsByPeriod({
    required int accountId,
    required String startDate,
    required String endDate,
  }) async {
    try {
      // 1. Сначала синхронизируем неотправленные операции
      await _syncPendingTransactionOperations();

      // 2. Загружаем актуальные данные с сервера
      final remoteTransactions = await _fetchTransactionsFromApi(
        accountId: accountId,
        startDate: startDate,
        endDate: endDate,
      );

      // 3. Сохраняем в локальную базу
      await databaseService.saveTransactions(remoteTransactions);

      return remoteTransactions;
    } catch (e) {
      // Если API недоступно, используем локальные данные
      return await databaseService.getAllTransactions(
        accountId: accountId,
        startDate: startDate,
        endDate: endDate,
      );
    }
  }

  @override
  Future<TransactionResponseEntity> createTransaction(
    TransactionRequestEntity transaction,
  ) async {
    // 1. Сначала сохраняем в локальную базу
    final createdTransaction = await databaseService.createTransaction(
      transaction,
    );

    // 2. Добавляем операцию в бэкап
    await databaseService.addBackupOperation(
      operationType: 'CREATE',
      entityType: 'transaction',
      entityId: createdTransaction.id.toString(),
      payload: TransactionRequestDtoMapper.fromEntity(transaction).toJson(),
    );

    // 3. Пробуем сразу синхронизировать
    await _syncPendingTransactionOperations();

    return createdTransaction;
  }

  @override
  Future<TransactionResponseEntity> updateTransaction({
    required TransactionRequestEntity transaction,
    required int id,
  }) async {
    // 1. Сначала обновляем локальную базу
    final updatedTransaction = await databaseService.updateTransaction(
      id: id,
      request: transaction,
    );

    // 2. Добавляем операцию в бэкап
    await databaseService.addBackupOperation(
      operationType: 'UPDATE',
      entityType: 'transaction',
      entityId: id.toString(),
      payload: TransactionRequestDtoMapper.fromEntity(transaction).toJson(),
    );

    // 3. Пробуем сразу синхронизировать
    await _syncPendingTransactionOperations();

    return updatedTransaction;
  }

  @override
  Future<void> deleteTransactionById(int id) async {
    // 1. Сначала удаляем из локальной базы
    await databaseService.deleteTransaction(id);

    // 2. Добавляем операцию в бэкап
    await databaseService.addBackupOperation(
      operationType: 'DELETE',
      entityType: 'transaction',
      entityId: id.toString(),
      payload: {'id': id},
    );

    // 3. Пробуем сразу синхронизировать
    await _syncPendingTransactionOperations();
  }

  Future<List<TransactionResponseEntity>> _fetchTransactionsFromApi({
    required int accountId,
    required String startDate,
    required String endDate,
  }) async {
    final response = await httpClient.get<List<dynamic>>(
      '$transactionsEndpoint/account/$accountId/period',
      queryParameters: {'startDate': startDate, 'endDate': endDate},
      options: Options(
        extra: {'_deserialize': (TransactionResponseDto.fromJson, true)},
      ),
    );

    return (response.data ?? [])
        .map((e) => (e as TransactionResponseDto).toEntity())
        .toList();
  }

  @override
  Future<void> syncPendingChanges() async {
    await _syncPendingTransactionOperations();
  }

  Future<void> _syncPendingTransactionOperations() async {
    final operations = await databaseService.getUnsyncedOperations(
      'transaction',
    );
    if (operations.isEmpty) return;

    final successfulIds = <String>[];

    for (final op in operations) {
      try {
        switch (op.operationType) {
          case 'CREATE':
            final response = await httpClient.post(
              transactionsEndpoint,
              data: op.payload,
            );
            final id = (response.data as Map<String, dynamic>)['id'];
            successfulIds.add(op.id);

            // Обновляем локальный ID если нужно
            await databaseService.updateTransactionId(
              oldId: int.parse(op.entityId),
              newId: id,
            );
            break;

          case 'UPDATE':
            await httpClient.put(
              '$transactionsEndpoint/${op.entityId}',
              data: op.payload,
            );
            successfulIds.add(op.id);
            break;

          case 'DELETE':
            await httpClient.delete('$transactionsEndpoint/${op.entityId}');
            successfulIds.add(op.id);
            break;
        }
      } catch (e) {
        // Логируем ошибку, но продолжаем пробовать остальные операции
        print('Failed to sync transaction operation ${op.id}: $e');
        break; // Прерываем при первой ошибке
      }
    }

    // Помечаем успешно отправленные операции
    if (successfulIds.isNotEmpty) {
      await databaseService.markAsSynced(successfulIds);
    }
  }
}
