import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_request_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/repository/i_transactions_repository.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/transaction/transaction_state.dart';

/// Кубит для операций над транзакцией
class TransactionOperationCubit extends Cubit<TransactionOperationState> {
  final ITransactionsRepository repository;

  TransactionOperationCubit(this.repository) : super(const TransactionOperationInitialState());

  /// Метод создания транзакции
  Future<void> createTransaction(TransactionRequestEntity request) async {
    emit(const TransactionOperationLoadingState());

    try {
      final newTransaction = await repository.createTransaction(request);
      emit(TransactionOperationSuccessState(transaction: newTransaction));
    } catch (error, stackTrace) {
      emit(TransactionOperationFailure(error: error, stackTrace: stackTrace));
    }
  }

  /// Метод редактирования транзакции
  Future<void> updateTransaction({
    required TransactionRequestEntity transaction,
    required int transactionId,
  }) async {
    emit(const TransactionOperationLoadingState());

    try {
      final newTransaction = await repository.updateTransaction(
        transaction: transaction,
        id: transactionId,
      );
      emit(TransactionOperationUpdateState(transaction: newTransaction));
    } catch (error, stackTrace) {
      emit(TransactionOperationFailure(error: error, stackTrace: stackTrace));
    }
  }

  /// Метод удаления транзакции
  Future<void> deleteTransaction(int transactionId) async {
    emit(const TransactionOperationLoadingState());

    try {
      await repository.deleteTransactionById(transactionId);
      emit(const TransactionOperationDeleteState());
    } catch (error, stackTrace) {
      emit(TransactionOperationFailure(error: error, stackTrace: stackTrace));
    }
  }
}
