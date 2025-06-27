import 'package:yandex_school_homework/app/env_config/env_config.dart';
import 'package:yandex_school_homework/di/di_base_repo.dart';
import 'package:yandex_school_homework/di/di_container.dart';
import 'package:yandex_school_homework/di/di_typedefs.dart';
import 'package:yandex_school_homework/features/Accounts/domain/repository/i_Accounts_repository.dart';
import 'package:yandex_school_homework/features/accounts/data/repository/accounts_mock_repository.dart';
import 'package:yandex_school_homework/features/accounts/data/repository/accounts_repository.dart';
import 'package:yandex_school_homework/features/categories/data/repository/categories_mock_repository.dart';
import 'package:yandex_school_homework/features/categories/data/repository/categories_repository.dart';
import 'package:yandex_school_homework/features/categories/domain/repository/i_categories_repository.dart';
import 'package:yandex_school_homework/features/transactions/data/repository/transactions_local_repository.dart';
import 'package:yandex_school_homework/features/transactions/data/repository/transactions_mock_repository.dart';
import 'package:yandex_school_homework/features/transactions/domain/repository/i_transactions_repository.dart';

final class DiRepositories {
  late final ICategoriesRepository categoriesRepository;
  late final IAccountsRepository accountsRepository;
  late final ITransactionsRepository transactionsRepository;

  void init({
    required OnProgress onProgress,
    required OnError onError,
    required DiContainer diContainer,
  }) {
    try {
      categoriesRepository = _lazyInitRepo<ICategoriesRepository>(
        mockFactory: CategoriesMockRepository.new,
        mainFactory: () =>
            CategoriesRepository(httpClient: diContainer.httpClient),
      );
      onProgress(categoriesRepository.name);
    } on Object catch (error, stackTrace) {
      onError(
        'Ошибка инициализации репозитория ICategoriesRepository',
        error,
        stackTrace,
      );
    }

    try {
      accountsRepository = _lazyInitRepo<IAccountsRepository>(
        mockFactory: AccountsMockRepository.new,
        mainFactory: () =>
            AccountsRepository(httpClient: diContainer.httpClient),
      );
      onProgress(accountsRepository.name);
    } on Object catch (error, stackTrace) {
      onError(
        'Ошибка инициализации репозитория IAccountsRepository',
        error,
        stackTrace,
      );
    }

    try {
      transactionsRepository = _lazyInitRepo<ITransactionsRepository>(
        mockFactory: TransactionsMockRepository.new,
        mainFactory: () =>
            //TransactionsRepository(httpClient: diContainer.httpClient),
            TransactionsLocalRepository(databaseService: diContainer.databaseService),
      );
      onProgress(transactionsRepository.name);
    } on Object catch (error, stackTrace) {
      onError(
        'Ошибка инициализации репозитория ITransactionsRepository',
        error,
        stackTrace,
      );
    }
  }

  T _lazyInitRepo<T extends DiBaseRepo>({
    required T Function() mainFactory,
    required T Function() mockFactory,
  }) {
    return EnvConfig.useMocks.toLowerCase() == 'true'
        ? mockFactory()
        : mainFactory();
  }
}
