import 'package:flutter_bloc/flutter_bloc.dart';
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
}
