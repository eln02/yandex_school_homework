import 'package:yandex_school_homework/app/http/i_http_client.dart';
import 'package:yandex_school_homework/features/accounts/domain/repository/i_accounts_repository.dart';
import 'package:yandex_school_homework/features/accounts/data/dto/account/account_dto.dart';
import 'package:yandex_school_homework/features/accounts/data/dto/account/account_dto_mapper.dart';
import 'package:yandex_school_homework/features/accounts/data/dto/account_update_request/account_update_request_dto_mapper.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_entity.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_update_request_entity.dart';

final class AccountsRepository implements IAccountsRepository {
  AccountsRepository({required this.httpClient});

  final IHttpClient httpClient;

  @override
  String get name => 'AccountsRepository';

  static const String accounts = 'accounts';

  @override
  Future<List<AccountEntity>> fetchAccounts() async {
    final response = await httpClient.get(accounts);

    final List<dynamic> data = response.data;
    return (data).map((item) => AccountDto.fromJson(item).toEntity()).toList();
  }

  @override
  Future<AccountEntity> updateAccount({
    required int id,
    required AccountUpdateRequestEntity account,
  }) async {
    final response = await httpClient.put(
      '$accounts/$id',
      data: AccountUpdateRequestDtoMapper.fromEntity(account).toJson(),
    );
    final Map<String, dynamic> data = response.data;
    return AccountDto.fromJson(data).toEntity();
  }
}
