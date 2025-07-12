import 'package:yandex_school_homework/di/di_container.dart';
import 'package:yandex_school_homework/di/di_typedefs.dart';
import 'package:yandex_school_homework/features/accounts/data/repository/accounts_backup_repository.dart';
import 'package:yandex_school_homework/features/accounts/domain/repository/i_accounts_repository.dart';
import 'package:yandex_school_homework/features/categories/data/repository/categories_backup_repository.dart';
import 'package:yandex_school_homework/features/categories/domain/repository/i_categories_repository.dart';
import 'package:yandex_school_homework/features/transactions/data/repository/transactions_backup_repository.dart';
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
      categoriesRepository = CategoriesBackupRepository(
        httpClient: diContainer.httpClient,
        databaseService: diContainer.databaseService,
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
      accountsRepository = AccountsBackupRepository(
        httpClient: diContainer.httpClient,
        databaseService: diContainer.databaseService,
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
      transactionsRepository = TransactionsBackupRepository(
        httpClient: diContainer.httpClient,
        databaseService: diContainer.databaseService,
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
}
