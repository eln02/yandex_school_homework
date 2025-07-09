import 'package:yandex_school_homework/app/http/i_http_client.dart';
import 'package:yandex_school_homework/app/database/i_database_service.dart';
import 'package:yandex_school_homework/features/accounts/domain/repository/i_accounts_repository.dart';
import 'package:yandex_school_homework/features/accounts/data/dto/account/account_dto.dart';
import 'package:yandex_school_homework/features/accounts/data/dto/account/account_dto_mapper.dart';
import 'package:yandex_school_homework/features/accounts/data/dto/account_update_request/account_update_request_dto_mapper.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_entity.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_update_request_entity.dart';

final class AccountsBackupRepository implements IAccountsRepository {
  AccountsBackupRepository({
    required this.httpClient,
    required this.databaseService,
  });

  final IHttpClient httpClient;
  final IDatabaseService databaseService;

  @override
  String get name => 'AccountsBackupRepository';

  static const String accountsEndpoint = 'accounts';

  @override
  Future<List<AccountEntity>> fetchAccounts() async {
    try {
      // 1. Сначала синхронизируем все ожидающие операции
      await _syncPendingAccountChanges();

      // 2. Затем получаем актуальные данные с сервера
      final remoteAccounts = await _fetchFromApi();

      // 3. Сохраняем в локальную базу
      await databaseService.saveAccounts(remoteAccounts);

      return remoteAccounts;
    } catch (e) {
      // Если API недоступно, используем локальные данные
      return await databaseService.getAllAccounts();
    }
  }

  Future<void> _syncPendingAccountChanges() async {
    final operations = await databaseService.getUnsyncedOperations('account');
    if (operations.isEmpty) return;

    final successfulIds = <String>[];

    for (final op in operations) {
      try {
        switch (op.operationType) {
          case 'UPDATE':
            await httpClient.put(
              '$accountsEndpoint/${op.entityId}',
              data: op.payload,
            );
            successfulIds.add(op.id);
            break;
        }
      } catch (e) {
        // Если ошибка - прерываем синхронизацию, чтобы не затереть данные
        // Следующая попытка будет при следующем запросе
        break;
      }
    }

    if (successfulIds.isNotEmpty) {
      await databaseService.markAsSynced(successfulIds);
    }
  }


  @override
  Future<AccountEntity> updateAccount({
    required int id,
    required AccountUpdateRequestEntity account,
  }) async {
    // 1. Сначала обновляем локальную базу
    final updatedAccount = await databaseService.updateAccount(
      id: id,
      request: account,
    );

    // 2. Добавляем операцию в бэкап
    await databaseService.addBackupOperation(
      operationType: 'UPDATE',
      entityType: 'account',
      entityId: id.toString(),
      payload: AccountUpdateRequestDtoMapper.fromEntity(account).toJson(),
    );

    // 3. Пробуем сразу синхронизировать
    await _syncPendingAccountChanges();

    return updatedAccount;
  }

  Future<List<AccountEntity>> _fetchFromApi() async {
    final response = await httpClient.get(accountsEndpoint);
    final data = response.data as List<dynamic>;
    return data.map((e) => AccountDto.fromJson(e).toEntity()).toList();
  }

}