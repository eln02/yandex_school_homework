import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_school_homework/features/Accounts/domain/repository/i_Accounts_repository.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_update_request_entity.dart';
import 'package:yandex_school_homework/features/accounts/domain/state/account_state.dart';

/// Кубит для работы с аккаунтом
class AccountCubit extends Cubit<AccountState> {
  AccountCubit(this.repository) : super(const AccountLoadingState());

  final IAccountsRepository repository;

  /// Метод получения аккаунта
  Future<void> fetchAccount() async {
    emit(const AccountLoadingState());

    try {
      final accounts = await repository.fetchAccounts();

      // TODO: переделать логику, если появится функционал выбора счета
      // пока по дефолту берется первый счет
      final account = accounts.firstOrNull;

      if (account == null) {
        throw StateError('Нет счета');
      }

      emit(AccountLoadedState(account: account));
    } on Object catch (error, stackTrace) {
      emit(
        AccountErrorState(
          stackTrace,
          errorMessage: "Не удалось загрузить счет",
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
    if (state is AccountLoadedState) {
      final currentState = state as AccountLoadedState;
      final currentAccount = currentState.account;

      final accountRequest = AccountUpdateRequestEntity(
        name: name ?? currentAccount.name,
        balance: balance ?? currentAccount.balance,
        currency: currency ?? currentAccount.currency,
      );

      // TODO: подумать над оптимистичным обновлением чтобы не обновлять весь экран
      emit(const AccountLoadingState());

      try {
        final updatedAccount = await repository.updateAccount(
          id: currentAccount.id,
          account: accountRequest,
        );

        emit(AccountLoadedState(account: updatedAccount));
      } on Object catch (error, stackTrace) {
        emit(
          AccountErrorState(
            stackTrace,
            errorMessage: "Не удалось обновить счет",
          ),
        );
      }
    }
  }
}
