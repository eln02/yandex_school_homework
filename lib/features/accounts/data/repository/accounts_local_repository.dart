import 'package:yandex_school_homework/features/accounts/domain/repository/i_accounts_repository.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_entity.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_update_request_entity.dart';
import 'package:yandex_school_homework/app/database/i_database_service.dart';

final class AccountsLocalRepository implements IAccountsRepository {
  AccountsLocalRepository({required this.databaseService});

  final IDatabaseService databaseService;

  @override
  String get name => 'AccountsLocalRepository';

  @override
  Future<List<AccountEntity>> fetchAccounts() async {
    return await databaseService.getAllAccounts();
  }

  @override
  Future<AccountEntity> updateAccount({
    required int id,
    required AccountUpdateRequestEntity account,
  }) async {
    return await databaseService.updateAccount(id: id, request: account);
  }
}
