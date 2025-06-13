import 'package:yandex_school_homework/features/transactions/data/dto/transaction_request/transaction_request_dto.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_request_entity.dart';

extension TransactionRequestDtoMapper on TransactionRequestDto {
  static TransactionRequestDto fromEntity(TransactionRequestEntity entity) {
    return TransactionRequestDto(
      accountId: entity.accountId,
      categoryId: entity.categoryId,
      amount: entity.amount,
      transactionDate: entity.transactionDate,
      comment: entity.comment,
    );
  }
}
