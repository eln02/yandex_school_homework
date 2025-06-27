import 'package:yandex_school_homework/features/transactions/domain/entity/category_analysis_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/transactions_state.dart';

/// Расширение на TransactionsLoadedState для группировки транзакций по категориям
extension CategoriesAnalysisExt on TransactionsLoadedState {
  /// Общая сумма доходов
  double get incomesSumDouble => incomes.fold(0.0, (sum, t) => sum + t.amount);

  /// Общая сумма расходов
  double get expensesSumDouble =>
      expenses.fold(0.0, (sum, t) => sum + t.amount);

  /// Группировка доходов: id -> CategoryAnalysisEntity
  Map<int, CategoryAnalysisEntity> get incomeCategoryMap =>
      _groupByCategory(incomes, total: incomesSumDouble);

  /// Группировка расходов: id -> CategoryAnalysisEntity
  Map<int, CategoryAnalysisEntity> get expenseCategoryMap =>
      _groupByCategory(expenses, total: expensesSumDouble);

  /// Список доходов для ui
  List<CategoryAnalysisEntity> get incomeCategoryList =>
      incomeCategoryMap.values.toList();

  /// Список расходов для ui
  List<CategoryAnalysisEntity> get expenseCategoryList =>
      expenseCategoryMap.values.toList();

  /// Приватный метод группировки транзакций
  /// Возвращает Map c ключом из id категории и значением объектом анализа категории
  Map<int, CategoryAnalysisEntity> _groupByCategory(
    List<TransactionResponseEntity> txs, {
    required double total,
  }) {
    final Map<int, List<TransactionResponseEntity>> grouped = {};

    for (final tx in txs) {
      final key = tx.category.id;
      grouped.putIfAbsent(key, () => []).add(tx);
    }

    final Map<int, CategoryAnalysisEntity> result = {};

    for (final entry in grouped.entries) {
      final txList = entry.value;
      if (txList.isEmpty) continue;

      txList.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
      final lastComment = txList.first.comment;

      final category = txList.first.category;
      final amount = txList.fold(0.0, (sum, t) => sum + t.amount);
      final percent = total == 0.0 ? 0.0 : (amount / total * 100);

      result[category.id] = CategoryAnalysisEntity(
        id: category.id,
        name: category.name,
        emoji: category.emoji,
        amount: amount,
        percent: percent,
        lastComment: lastComment,
        transactions: txList,
      );
    }

    return result;
  }
}
