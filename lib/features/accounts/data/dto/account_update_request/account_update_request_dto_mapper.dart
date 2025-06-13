import 'package:yandex_school_homework/features/accounts/domain/entity/account_update_request_entity.dart';

import 'account_update_request_dto.dart';

extension AccountUpdateRequestDtoMapper on AccountUpdateRequestDto {
  static AccountUpdateRequestDto fromEntity(AccountUpdateRequestEntity entity) {
    return AccountUpdateRequestDto(
      name: entity.name,
      balance: entity.balance,
      currency: entity.currency,
    );
  }
}
