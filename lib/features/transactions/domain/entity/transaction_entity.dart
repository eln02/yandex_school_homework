import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final int id;
  final int accountId;
  final int categoryId;
  final String amount;
  final DateTime transactionDate;
  final String? comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TransactionEntity({
    required this.id,
    required this.accountId,
    required this.categoryId,
    required this.amount,
    required this.transactionDate,
    this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    accountId,
    categoryId,
    amount,
    transactionDate,
    comment,
    createdAt,
    updatedAt,
  ];
}
