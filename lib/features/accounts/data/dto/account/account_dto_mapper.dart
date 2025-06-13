import 'package:yandex_school_homework/features/accounts/data/dto/account/account_dto.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_entity.dart';

extension AccountDtoMapper on AccountDto {
  AccountEntity toEntity() {
    return AccountEntity(
      id: id,
      userId: userId,
      name: name,
      balance: balance,
      currency: currency,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
