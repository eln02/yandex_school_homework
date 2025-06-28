import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_entity.dart';

/// Состояние для работы со счетом
@immutable
sealed class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object?> get props => [];
}

/// Состояние загрузки счета
final class AccountLoadingState extends AccountState {
  const AccountLoadingState();
}

/// Состояние успешной загрузки счета
final class AccountLoadedState extends AccountState {
  const AccountLoadedState({required this.account});

  /// Счет
  final AccountEntity account;

  /*/// Геттер id аккаунта
  @override
  int get accountId => account.id;*/

  @override
  List<Object?> get props => [account];
}

/// Состояние ошибки загрузки счета
final class AccountErrorState extends AccountState {
  const AccountErrorState(this.stackTrace, {required this.errorMessage});

  final String errorMessage;
  final StackTrace? stackTrace;

  @override
  List<Object?> get props => [errorMessage, stackTrace];
}
