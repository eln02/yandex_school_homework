import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_dto.freezed.dart';

part 'transaction_dto.g.dart';

@freezed
class TransactionDto with _$TransactionDto {
  const factory TransactionDto({
    required int id,
    required int accountId,
    required int categoryId,
    required String amount,
    required DateTime transactionDate,
    String? comment,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TransactionDto;

  factory TransactionDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionDtoFromJson(json);
}
