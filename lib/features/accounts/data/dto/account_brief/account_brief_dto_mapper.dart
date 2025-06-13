import 'package:yandex_school_homework/features/accounts/data/dto/account_brief/account_brief_dto.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_brief_entity.dart';

extension AccountBriefDtoMapper on AccountBriefDto {
  AccountBriefEntity toEntity() {
    return AccountBriefEntity(
      id: id,
      name: name,
      balance: balance,
      currency: currency,
    );
  }
}
