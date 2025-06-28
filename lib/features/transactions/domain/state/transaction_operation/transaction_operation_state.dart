import 'package:equatable/equatable.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';

/// Состояние транзакции
sealed class TransactionOperationState extends Equatable {
  const TransactionOperationState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние транзакции
class TransactionOperationInitialState extends TransactionOperationState {
  const TransactionOperationInitialState();
}

/// Состояние загрузки отправки транзакции
class TransactionOperationLoadingState extends TransactionOperationState {
  const TransactionOperationLoadingState();
}

/// Состояние после успешной отправки транзакции
class TransactionOperationSuccessState extends TransactionOperationState {
  final TransactionResponseEntity transaction;

  /// транзакция
  const TransactionOperationSuccessState({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}

/// Состояние ошибки отправки транзакции
class TransactionOperationFailure extends TransactionOperationState {
  final dynamic error;
  final StackTrace stackTrace;

  const TransactionOperationFailure({
    required this.error,
    required this.stackTrace,
  });

  @override
  List<Object?> get props => [error, stackTrace];
}
