import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_request_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/repository/i_transactions_repository.dart';

class TransactionOperationCubit extends Cubit<TransactionOperationState> {
  final ITransactionsRepository repository;

  TransactionOperationCubit(this.repository)
    : super(const TransactionOperationInitial());

  Future<void> createTransaction(TransactionRequestEntity request) async {
    emit(const TransactionOperationInProgress());

    try {
      final newTransaction = await repository.createTransaction(request);
      emit(TransactionOperationSuccess(transaction: newTransaction));
    } catch (error, stackTrace) {
      print('ошибка');
      print(error.toString());
      emit(TransactionOperationFailure(error: error, stackTrace: stackTrace));
    }
  }
}

// transaction_operation_state.dart
sealed class TransactionOperationState {
  const TransactionOperationState();
}

class TransactionOperationInitial extends TransactionOperationState {
  const TransactionOperationInitial();
}

class TransactionOperationInProgress extends TransactionOperationState {
  const TransactionOperationInProgress();
}

class TransactionOperationSuccess extends TransactionOperationState {
  final TransactionResponseEntity transaction;

  const TransactionOperationSuccess({required this.transaction});
}

class TransactionOperationFailure extends TransactionOperationState {
  final dynamic error;
  final StackTrace stackTrace;

  const TransactionOperationFailure({
    required this.error,
    required this.stackTrace,
  });
}
