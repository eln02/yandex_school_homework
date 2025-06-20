import 'package:yandex_school_homework/features/accounts/data/dto/account_brief/account_brief_dto_mapper.dart';
import 'package:yandex_school_homework/features/categories/data/dto/category_dto_mapper.dart';
import 'package:yandex_school_homework/features/transactions/data/dto/transaction_response/transaction_response_dto.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';

extension TransactionResponseDtoMapper on TransactionResponseDto {
  TransactionResponseEntity toEntity() {
    return TransactionResponseEntity(
      id: id,
      account: account.toEntity(),
      category: category.toEntity(),
      amount: double.tryParse(amount) ?? 0.0,
      transactionDate: transactionDate,
      comment: comment,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
