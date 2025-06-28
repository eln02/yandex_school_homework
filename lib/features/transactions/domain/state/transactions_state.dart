import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/sorting_enum.dart';

/// Состояние для работы с транзакциями
@immutable
sealed class TransactionsState extends Equatable {
  const TransactionsState();

  @override
  List<Object?> get props => [];
}

/// Состояние загрузки транзакций
final class TransactionsLoadingState extends TransactionsState {
  const TransactionsLoadingState();
}

/// Состояние успешной загрузки транзакций
final class TransactionsLoadedState extends TransactionsState {
  const TransactionsLoadedState({required this.transactions});

  /// Все полученные транзакции
  final List<TransactionResponseEntity> transactions;

  /// Тип валюты в аккаунте
  // TODO: возможно убрать при появлении логики аккаунтов
  String get currency =>
      transactions.isEmpty ? '' : transactions.first.account.currency;

  /// Доходы
  List<TransactionResponseEntity> get incomes =>
      transactions.where((t) => t.category.isIncome).toList();

  /// Расходы
  List<TransactionResponseEntity> get expenses =>
      transactions.where((t) => !t.category.isIncome).toList();

  /// Сумма доходов
  String get incomesSum =>
      incomes.fold(0.0, (sum, t) => sum + t.amount).toStringAsFixed(0);

  /// Сумма расходов
  String get expensesSum =>
      expenses.fold(0.0, (sum, t) => sum + t.amount).toStringAsFixed(0);

  /// Отсортированные доходы
  List<TransactionResponseEntity> sortedIncomes(SortingType sorting) =>
      _sort(incomes, sorting);

  /// Отсортированные расходы
  List<TransactionResponseEntity> sortedExpenses(SortingType sorting) =>
      _sort(expenses, sorting);

  /// Метод сортировки в зависимости от выбранной сортировки
  List<TransactionResponseEntity> _sort(
    List<TransactionResponseEntity> txs,
    SortingType sorting,
  ) {
    switch (sorting) {
      case SortingType.dateNewestFirst:
        return [...txs]
          ..sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
      case SortingType.dateOldestFirst:
        return [...txs]
          ..sort((a, b) => a.transactionDate.compareTo(b.transactionDate));
      case SortingType.amountHighToLow:
        return [...txs]..sort((a, b) => b.amount.compareTo(a.amount));
      case SortingType.amountLowToHigh:
        return [...txs]..sort((a, b) => a.amount.compareTo(b.amount));
    }
  }

  @override
  List<Object?> get props => [transactions];
}

/// Состояние ошибки загрузки транзакций
final class TransactionsErrorState extends TransactionsState {
  const TransactionsErrorState(this.stackTrace, {required this.errorMessage});

  final String errorMessage;
  final StackTrace? stackTrace;

  @override
  List<Object?> get props => [errorMessage, stackTrace];
}
