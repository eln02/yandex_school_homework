import 'package:yandex_school_homework/app/database/i_database_service.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_request_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/repository/i_transactions_repository.dart';

/// Локальный репозитори для работы с транзакциями
/// Работает только с базой данных
final class TransactionsLocalRepository implements ITransactionsRepository {
  TransactionsLocalRepository({required this.databaseService});

  final IDatabaseService databaseService;

  @override
  String get name => 'TransactionsLocalRepository';

  /// Метод создания транзакции
  @override
  Future<TransactionResponseEntity> createTransaction(
    TransactionRequestEntity transaction,
  ) async {
    final data = await databaseService.createTransaction(transaction);

    return data;
  }

  /// Метод получения транзакций за период
  @override
  Future<List<TransactionResponseEntity>> fetchTransactionsByPeriod({
    required int accountId,
    required String startDate,
    required String endDate,
  }) async {
    final data = await databaseService.getAllTransactions(
      accountId: accountId,
      startDate: startDate,
      endDate: endDate,
    );

    return data;
  }

  // TODO: добавить остальные методы
  @override
  Future<void> deleteTransactionById(int id) {
    // TODO: implement deleteTransactionById
    throw UnimplementedError();
  }

  @override
  Future<TransactionResponseEntity> fetchTransactionById(int id) {
    // TODO: implement fetchTransactionById
    throw UnimplementedError();
  }

  @override
  Future<TransactionResponseEntity> updateTransaction({
    required TransactionRequestEntity transaction,
    required int id,
  }) {
    // TODO: implement updateTransaction
    throw UnimplementedError();
  }
}
