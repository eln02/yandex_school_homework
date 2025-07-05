// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionRequestDtoImpl _$$TransactionRequestDtoImplFromJson(
  Map<String, dynamic> json,
) => _$TransactionRequestDtoImpl(
  accountId: (json['accountId'] as num).toInt(),
  categoryId: (json['categoryId'] as num).toInt(),
  amount: json['amount'] as String,
  transactionDate: DateTime.parse(json['transactionDate'] as String),
  comment: json['comment'] as String?,
);

Map<String, dynamic> _$$TransactionRequestDtoImplToJson(
  _$TransactionRequestDtoImpl instance,
) => <String, dynamic>{
  'accountId': instance.accountId,
  'categoryId': instance.categoryId,
  'amount': instance.amount,
  'transactionDate': instance.transactionDate.toIso8601String(),
  'comment': instance.comment,
};
