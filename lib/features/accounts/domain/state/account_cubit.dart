import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_school_homework/features/accounts/domain/repository/i_accounts_repository.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_update_request_entity.dart';
import 'package:yandex_school_homework/features/accounts/domain/state/account_state.dart';

/// Кубит для работы с аккаунтом
class AccountCubit extends Cubit<AccountState> {
  AccountCubit(this.repository) : super(const AccountLoadingState());

  final IAccountsRepository repository;

  /// Метод получения аккаунтов
  Future<void> fetchAccount() async {
    emit(const AccountLoadingState());

    try {
      final accounts = await repository.fetchAccounts();

      if (accounts.isEmpty) {
        emit(const AccountErrorState(null, errorMessage: "Нет счета"));
        return;
      }

      emit(AccountLoadedState(accounts: accounts));
    } on Object catch (error, stackTrace) {
      emit(
        AccountErrorState(
          stackTrace,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  /// Метод обновления аккаунта
  Future<void> updateAccount({
    String? balance,
    String? currency,
    String? name,
  }) async {
    if (state is! AccountLoadedState) return;

    final currentState = state as AccountLoadedState;
    final currentAccount = currentState.account;

    // Создаем оптимистично обновленный аккаунт
    final optimisticAccount = currentAccount.copyWith(
      name: name,
      balance: balance,
      currency: currency,
    );

    // Создаем оптимистично обновленный список
    final optimisticAccounts = currentState.accounts.map((account) {
      return account.id == currentAccount.id ? optimisticAccount : account;
    }).toList();

    // Сразу показываем изменения пользователю
    emit(AccountLoadedState(accounts: optimisticAccounts));

    final accountRequest = AccountUpdateRequestEntity(
      name: name ?? currentAccount.name,
      balance: balance ?? currentAccount.balance,
      currency: currency ?? currentAccount.currency,
    );

    try {
      final updatedAccount = await repository.updateAccount(
        id: currentAccount.id,
        account: accountRequest,
      );

      // Если сервер вернул другие данные - используем их
      final finalAccounts = currentState.accounts.map((account) {
        return account.id == updatedAccount.id ? updatedAccount : account;
      }).toList();

      emit(AccountLoadedState(accounts: finalAccounts));
    } on Object catch (error, stackTrace) {
      // В случае ошибки - возвращаем предыдущее состояние
      emit(AccountErrorState(
        stackTrace,
        errorMessage: error.toString(),
      ));

      // Возвращаем оригинальные данные
      emit(currentState);
    }
  }
}
