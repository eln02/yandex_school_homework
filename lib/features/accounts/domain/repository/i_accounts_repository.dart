import 'package:yandex_school_homework/di/di_base_repo.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_entity.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_update_request_entity.dart';

abstract interface class IAccountsRepository with DiBaseRepo {
  Future<List<AccountEntity>> fetchAccounts();

  Future<AccountEntity> updateAccount({
    required int id,
    required AccountUpdateRequestEntity account,
  });

  Future<void> syncPendingChanges() async {}
}
