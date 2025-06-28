import 'package:equatable/equatable.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';

/// Сущность данных анализа по категории
class CategoryAnalysisEntity extends Equatable {
  final int id;
  final String name;
  final String emoji;

  /// Последний комментарий в списке транзакций
  final String? lastComment;

  /// Процент дохода/расхода от общей суммы
  final double percent;

  /// Сумма дохода/расхода по категории
  final double amount;

  /// Транзакции в категории
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
