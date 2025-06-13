// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_update_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountUpdateRequestDtoImpl _$$AccountUpdateRequestDtoImplFromJson(
  Map<String, dynamic> json,
) => _$AccountUpdateRequestDtoImpl(
  name: json['name'] as String,
  balance: json['balance'] as String,
  currency: json['currency'] as String,
);

Map<String, dynamic> _$$AccountUpdateRequestDtoImplToJson(
  _$AccountUpdateRequestDtoImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'balance': instance.balance,
  'currency': instance.currency,
};
