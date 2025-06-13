import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_school_homework/features/accounts/data/dto/account_brief/account_brief_dto.dart';
import 'package:yandex_school_homework/features/categories/data/dto/category_dto.dart';

part 'transaction_response_dto.freezed.dart';

part 'transaction_response_dto.g.dart';

@freezed
class TransactionResponseDto with _$TransactionResponseDto {
  const factory TransactionResponseDto({
    required int id,
    required AccountBriefDto account,
    required CategoryDto category,
    required String amount,
    required DateTime transactionDate,
    String? comment,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TransactionResponseDto;

  factory TransactionResponseDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseDtoFromJson(json);
}
