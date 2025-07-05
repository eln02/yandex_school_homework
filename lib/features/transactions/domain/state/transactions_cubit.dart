import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/repository/i_transactions_repository.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/transactions_state.dart';

/// Кубит для работы с транзакциями
class TransactionsCubit extends Cubit<TransactionsState> {
  TransactionsCubit(this.repository) : super(const TransactionsLoadingState());

  final ITransactionsRepository repository;

  /// Метод получения транзакций
  Future<void> fetchTransactions({
    required int accountId,
    required String startDate,
    required String endDate,
  }) async {
    emit(const TransactionsLoadingState());

    try {
      final transactions = await repository.fetchTransactionsByPeriod(
        accountId: accountId,
        startDate: startDate,
        endDate: endDate,
      );

      emit(TransactionsLoadedState(transactions: transactions));
    } on Object catch (error, stackTrace) {
      emit(
        TransactionsErrorState(
          stackTrace,
          errorMessage: "Не удалось загрузить транзакции",
        ),
      );
    }
  }

  /// Добавление новой транзакции
  /// (чтобы не перезагружать весь список после создания новой транзакции)
  void addNewTransaction(TransactionResponseEntity transaction) {
    if (state is TransactionsLoadedState) {
      final currentState = state as TransactionsLoadedState;
      emit(
        TransactionsLoadedState(
          transactions: [transaction, ...currentState.transactions],
        ),
      );
    }
  }

  /// Обновление транзакции
  /// (чтобы не перезагружать весь список после обновления одной транзакции)
  void updateTransaction(TransactionResponseEntity updatedTransaction) {
    if (state is TransactionsLoadedState) {
      final currentState = state as TransactionsLoadedState;

      final updatedTransactions = currentState.transactions.map((transaction) {
        return transaction.id == updatedTransaction.id
            ? updatedTransaction
            : transaction;
      }).toList();

      emit(TransactionsLoadedState(transactions: updatedTransactions));
    }
  }
}
