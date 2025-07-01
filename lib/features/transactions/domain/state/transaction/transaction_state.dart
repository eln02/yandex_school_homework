import 'package:equatable/equatable.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';

/// Состояние транзакции
sealed class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние транзакции
class TransactionInitialState extends TransactionState {
  const TransactionInitialState();
}

/// Состояние загрузки отправки транзакции
class TransactionLoadingState extends TransactionState {
  const TransactionLoadingState();
}

/// Состояние после успешной отправки транзакции
class TransactionSuccessState extends TransactionState {
  final TransactionResponseEntity transaction;

  /// транзакция
  const TransactionSuccessState({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}

/// Состояние ошибки отправки транзакции
class TransactionFailure extends TransactionState {
  final dynamic error;
  final StackTrace stackTrace;

  const TransactionFailure({
    required this.error,
    required this.stackTrace,
  });

  @override
  List<Object?> get props => [error, stackTrace];
}
