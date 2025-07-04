import 'package:yandex_school_homework/features/transactions/domain/entity/cash_flow_analysis_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/transactions_state.dart';

/// Расширение для анализа денежного потока по дням
extension DailyCashFlowAnalysisExt on TransactionsLoadedState {
  /// Возвращает список CashFlowAnalysisEntity за последние 30 дней
  List<CashFlowAnalysisEntity> get dailyCashFlowLast30Days {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    // Фильтруем транзакции за последние 30 дней
    final recentTransactions = transactions
        .where(
          (tx) =>
              tx.transactionDate.isAfter(thirtyDaysAgo) &&
              tx.transactionDate.isBefore(now.add(const Duration(days: 1))),
        )
        .toList();

    // Группируем по дням
    final Map<DateTime, List<TransactionResponseEntity>> dailyGroups = {};

    for (final tx in recentTransactions) {
      // Нормализуем дату (без времени)
      final date = DateTime(
        tx.transactionDate.year,
        tx.transactionDate.month,
        tx.transactionDate.day,
      );

      dailyGroups.putIfAbsent(date, () => []).add(tx);
    }

    // Создаем записи для каждого дня (даже если не было транзакций)
    final List<CashFlowAnalysisEntity> result = [];

    for (int i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: 29 - i));
      final normalizedDate = DateTime(date.year, date.month, date.day);

      final dailyTransactions = dailyGroups[normalizedDate] ?? [];

      final income = dailyTransactions
          .where((t) => t.category.isIncome)
          .fold(0.0, (sum, t) => sum + t.amount);

      final expense = dailyTransactions
          .where((t) => !t.category.isIncome)
          .fold(0.0, (sum, t) => sum + t.amount);

      result.add(
        CashFlowAnalysisEntity(
          id: i, // Используем индекс как ID для простоты
          date: normalizedDate,
          flow: income - expense,
        ),
      );
    }

    return result;
  }

  /// Анализ за последние 12 месяцев (по месяцам)
  List<CashFlowAnalysisEntity> get monthlyCashFlowLast12Months {
    final now = DateTime.now();
    final twelveMonthsAgo = DateTime(now.year - 1, now.month, 1);

    // Фильтруем транзакции за последние 12 месяцев
    final recentTransactions = transactions
        .where((tx) => tx.transactionDate.isAfter(twelveMonthsAgo))
        .toList();

    // Группируем по месяцам
    final Map<DateTime, List<TransactionResponseEntity>> monthlyGroups = {};

    for (final tx in recentTransactions) {
      // Нормализуем дату (первый день месяца без времени)
      final date = DateTime(
        tx.transactionDate.year,
        tx.transactionDate.month,
        1,
      );
      monthlyGroups.putIfAbsent(date, () => []).add(tx);
    }

    // Создаем записи для каждого месяца (даже если не было транзакций)
    final List<CashFlowAnalysisEntity> result = [];

    for (int i = 0; i < 12; i++) {
      var date = DateTime(now.year, now.month - 11 + i, 1);
      if (date.month < 1) {
        date = DateTime(date.year - 1, date.month + 12, 1);
      }

      final monthlyTransactions = monthlyGroups[date] ?? [];

      final income = monthlyTransactions
          .where((t) => t.category.isIncome)
          .fold(0.0, (sum, t) => sum + t.amount);

      final expense = monthlyTransactions
          .where((t) => !t.category.isIncome)
          .fold(0.0, (sum, t) => sum + t.amount);

      result.add(
        CashFlowAnalysisEntity(id: i, date: date, flow: income - expense),
      );
    }

    return result;
  }
}
