import 'package:equatable/equatable.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_brief_entity.dart';
import 'package:yandex_school_homework/features/categories/domain/entity/category_entity.dart';

class TransactionResponseEntity extends Equatable {
  final int id;
  final AccountBriefEntity account;
  final CategoryEntity category;
  final String amount;
  final DateTime transactionDate;
  final String? comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TransactionResponseEntity({
    required this.id,
    required this.account,
    required this.category,
    required this.amount,
    required this.transactionDate,
    this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    account,
    category,
    amount,
    transactionDate,
    comment,
    createdAt,
    updatedAt,
  ];
}
