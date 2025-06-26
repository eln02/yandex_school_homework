import 'package:equatable/equatable.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';

class CategoryAnalysisEntity extends Equatable {
  final int id;
  final String name;
  final String emoji;
  final String? lastComment;
  final double percent;
  final double amount;
  final List<TransactionResponseEntity> transactions;

  const CategoryAnalysisEntity({
    required this.id,
    required this.name,
    required this.emoji,
    required this.percent,
    required this.amount,
    this.lastComment,
    required this.transactions,
  });

  @override
  List<Object?> get props => [id, name, emoji, percent, amount, lastComment];
}
