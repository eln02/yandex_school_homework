import 'package:yandex_school_homework/features/transactions/domain/entity/category_analysis_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/transactions_state.dart';

extension CategoriesAnalysisExt on TransactionsLoadedState {
  /// Общая сумма доходов
  double get incomesSumDouble =>
      incomes.fold(0.0, (sum, t) => sum + t.amount);

  /// Общая сумма расходов
  double get expensesSumDouble =>
      expenses.fold(0.0, (sum, t) => sum + t.amount);

  /// Группировка доходов по категориям с агрегированными данными
  Map<CategoryAnalysisEntity, List<TransactionResponseEntity>>
  get incomeCategoryMap =>
      _groupByCategory(incomes, total: incomesSumDouble);

  /// Группировка расходов по категориям с агрегированными данными
  Map<CategoryAnalysisEntity, List<TransactionResponseEntity>>
  get expenseCategoryMap =>
      _groupByCategory(expenses, total: expensesSumDouble);

  /// Список группированных категорий для UI (сохранён порядок)
  List<MapEntry<CategoryAnalysisEntity, List<TransactionResponseEntity>>>
  get incomeCategoryEntries => incomeCategoryMap.entries.toList();

  List<MapEntry<CategoryAnalysisEntity, List<TransactionResponseEntity>>>
  get expenseCategoryEntries => expenseCategoryMap.entries.toList();

  /// Приватная функция группировки транзакций по имени категории
  Map<CategoryAnalysisEntity, List<TransactionResponseEntity>> _groupByCategory(
      List<TransactionResponseEntity> txs, {
        required double total,
      }) {
    final Map<String, List<TransactionResponseEntity>> grouped = {};

    for (final tx in txs) {
      final key = tx.category.name;
      grouped.putIfAbsent(key, () => []).add(tx);
    }

    final Map<CategoryAnalysisEntity, List<TransactionResponseEntity>> result =
    {};

    for (final entry in grouped.entries) {
      final txList = entry.value;
      if (txList.isEmpty) continue;

      // Сортировка по дате (для получения последнего комментария)
      txList.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
      final lastComment = txList.first.comment;

      final category = txList.first.category;
      final amount = txList.fold(0.0, (sum, t) => sum + t.amount);
      final percent = total == 0.0 ? 0.0 : (amount / total * 100);

      final analysisEntity = CategoryAnalysisEntity(
        name: category.name,
        emoji: category.emoji,
        amount: amount,
        percent: percent,
        lastComment: lastComment,
      );

      result[analysisEntity] = txList;
    }

    return result;
  }
}
