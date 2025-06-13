// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_brief_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountBriefDtoImpl _$$AccountBriefDtoImplFromJson(
  Map<String, dynamic> json,
) => _$AccountBriefDtoImpl(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  balance: json['balance'] as String,
  currency: json['currency'] as String,
);

Map<String, dynamic> _$$AccountBriefDtoImplToJson(
  _$AccountBriefDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'balance': instance.balance,
  'currency': instance.currency,
};
