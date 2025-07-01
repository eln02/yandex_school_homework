import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_request_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/repository/i_transactions_repository.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/transaction/transaction_state.dart';

/// Кубит для операций над транзакцией
class TransactionCubit extends Cubit<TransactionState> {
  final ITransactionsRepository repository;

  TransactionCubit(this.repository) : super(const TransactionInitialState());

  /// Метод создания транзакции
  Future<void> createTransaction(TransactionRequestEntity request) async {
    emit(const TransactionLoadingState());

    try {
      final newTransaction = await repository.createTransaction(request);
      emit(TransactionSuccessState(transaction: newTransaction));
    } catch (error, stackTrace) {
      emit(TransactionFailure(error: error, stackTrace: stackTrace));
    }
  }
}
