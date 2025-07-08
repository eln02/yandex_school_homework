import 'package:yandex_school_homework/features/accounts/domain/entity/account_brief_entity.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_entity.dart';
import 'package:yandex_school_homework/features/categories/domain/entity/category_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';

extension AccountEntityMapper on AccountEntity {
  AccountBriefEntity toBrief() => AccountBriefEntity(
    id: id,
    name: name,
    balance: balance,
    currency: currency,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'name': name,
    'balance': balance,
    'currency': currency,
    'createdAt': createdAt.millisecondsSinceEpoch,
    'updatedAt': updatedAt.millisecondsSinceEpoch,
  };
}

extension AccountMapMapper on Map<String, dynamic> {
  AccountEntity toAccountEntity() => AccountEntity(
    id: this['id'] as int,
    userId: this['userId'] as int,
    name: this['name'] as String,
    balance: this['balance'] as String,
    currency: this['currency'] as String,
    createdAt: DateTime.fromMillisecondsSinceEpoch(this['createdAt'] as int),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(this['updatedAt'] as int),
  );
}

extension CategoryMapMapper on Map<String, dynamic> {
  CategoryEntity toCategoryEntity() => CategoryEntity(
    id: this['id'] as int,
    name: this['name'] as String,
    emoji: this['emoji'] as String,
    isIncome: (this['isIncome'] as int) == 1,
  );
}

extension TransactionMapMapper on Map<String, dynamic> {
  TransactionResponseEntity toTransactionEntity({
    required AccountEntity account,
    required CategoryEntity category,
  }) =>
      TransactionResponseEntity(
        id: this['id'] as int,
        account: account.toBrief(),
        category: category,
        amount: this['amount'] as double,
        transactionDate:
        DateTime.fromMillisecondsSinceEpoch(this['transactionDate'] as int),
        comment: this['comment'] as String?,
        createdAt: DateTime.fromMillisecondsSinceEpoch(this['createdAt'] as int),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(this['updatedAt'] as int),
      );
}