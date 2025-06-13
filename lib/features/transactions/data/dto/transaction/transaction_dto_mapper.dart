import 'package:yandex_school_homework/features/transactions/data/dto/transaction/transaction_dto.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_entity.dart';

extension TransactionDtoMapper on TransactionDto {
  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      amount: amount,
      transactionDate: transactionDate,
      comment: comment,
      createdAt: createdAt,
      updatedAt: updatedAt,
      accountId: accountId,
      categoryId: categoryId,
    );
  }
}
