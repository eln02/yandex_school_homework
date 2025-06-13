import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_brief_dto.freezed.dart';

part 'account_brief_dto.g.dart';

@freezed
class AccountBriefDto with _$AccountBriefDto {
  const factory AccountBriefDto({
    required int id,
    required String name,
    required String balance,
    required String currency,
  }) = _AccountBriefDto;

  factory AccountBriefDto.fromJson(Map<String, dynamic> json) =>
      _$AccountBriefDtoFromJson(json);
}
