import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_request_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/repository/i_transactions_repository.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/transaction_operation/transaction_operation_state.dart';

/// Кубит для создания транзакции
class TransactionOperationCubit extends Cubit<TransactionOperationState> {
  final ITransactionsRepository repository;

  TransactionOperationCubit(this.repository)
    : super(const TransactionOperationInitialState());

  /// Метод создания ттранзакции
  Future<void> createTransaction(TransactionRequestEntity request) async {
    emit(const TransactionOperationLoadingState());

    try {
      final newTransaction = await repository.createTransaction(request);
      emit(TransactionOperationSuccessState(transaction: newTransaction));
    } catch (error, stackTrace) {
      emit(TransactionOperationFailure(error: error, stackTrace: stackTrace));
    }
  }
}
