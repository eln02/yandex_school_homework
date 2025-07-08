import 'package:yandex_school_homework/features/accounts/domain/repository/i_accounts_repository.dart';
import 'package:yandex_school_homework/features/accounts/data/dto/account/account_dto.dart';
import 'package:yandex_school_homework/features/accounts/data/dto/account/account_dto_mapper.dart';
import 'package:yandex_school_homework/features/accounts/data/mock_data/accounts_mock_data.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_entity.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_update_request_entity.dart';

final class AccountsMockRepository implements IAccountsRepository {
  @override
  String get name => 'AccountsMockRepository';

  @override
  Future<List<AccountEntity>> fetchAccounts() async {
    await Future.delayed(const Duration(seconds: 1));
    final List<dynamic> accounts = AccountsMockData.accounts;

    return accounts
        .map((json) => AccountDto.fromJson(json).toEntity())
        .toList();
  }

  @override
  Future<AccountEntity> updateAccount({
    required int id,
    required AccountUpdateRequestEntity account,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    final account = AccountsMockData.accounts[0];
    return AccountDto.fromJson(account).toEntity();
  }
}
