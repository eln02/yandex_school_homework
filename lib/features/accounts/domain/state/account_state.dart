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
  const AccountLoadedState({required this.accounts});

  /// Счет
  final List<AccountEntity> accounts;

  // TODO: переделать логику, если появится функционал выбора счета
  /// Первый счет в качестве дефолтного
  AccountEntity get account {
    final firstAccount = accounts.firstOrNull;
    if (firstAccount == null) {
      throw StateError('Нет счета');
    }
    return firstAccount;
  }

  /*/// Геттер id аккаунта
  @override
  int get accountId => account.id;*/

  @override
  List<Object?> get props => [accounts];
}

/// Состояние ошибки загрузки счета
final class AccountErrorState extends AccountState {
  const AccountErrorState(this.stackTrace, {required this.errorMessage});

  final String errorMessage;
  final StackTrace? stackTrace;

  @override
  List<Object?> get props => [errorMessage, stackTrace];
}
