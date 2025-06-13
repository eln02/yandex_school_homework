import 'package:equatable/equatable.dart';

class TransactionRequestEntity extends Equatable {
  final int accountId;
  final int categoryId;
  final String amount;
  final DateTime transactionDate;
  final String? comment;

  const TransactionRequestEntity({
    required this.accountId,
    required this.categoryId,
    required this.amount,
    required this.transactionDate,
    this.comment,
  });

  @override
  List<Object?> get props => [
    accountId,
    categoryId,
    amount,
    transactionDate,
    comment,
  ];
}
