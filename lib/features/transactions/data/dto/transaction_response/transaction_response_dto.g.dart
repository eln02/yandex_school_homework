// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionResponseDtoImpl _$$TransactionResponseDtoImplFromJson(
  Map<String, dynamic> json,
) => _$TransactionResponseDtoImpl(
  id: (json['id'] as num).toInt(),
  account: AccountBriefDto.fromJson(json['account'] as Map<String, dynamic>),
  category: CategoryDto.fromJson(json['category'] as Map<String, dynamic>),
  amount: json['amount'] as String,
  transactionDate: DateTime.parse(json['transactionDate'] as String),
  comment: json['comment'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$TransactionResponseDtoImplToJson(
  _$TransactionResponseDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'account': instance.account,
  'category': instance.category,
  'amount': instance.amount,
  'transactionDate': instance.transactionDate.toIso8601String(),
  'comment': instance.comment,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
