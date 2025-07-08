import 'package:yandex_school_homework/features/accounts/domain/entity/account_entity.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_update_request_entity.dart';
import 'package:yandex_school_homework/features/categories/domain/entity/category_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_request_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';

/// Сервис для работы с базой данных
abstract class IDatabaseService {
  /// Метод получения всех транзакций
  Future<List<TransactionResponseEntity>> getAllTransactions({
    required int accountId,
    required String startDate,
    required String endDate,
  });

  /// Метод создания транзакции
  Future<TransactionResponseEntity> createTransaction(
    TransactionRequestEntity request,
  );

  /// Метод удаления транзакции
  Future<void> deleteTransaction(int id);

  /// Метод обновления транзакции
  Future<TransactionResponseEntity> updateTransaction({
    required int id,
    required TransactionRequestEntity request,
  });

  /// Метод получения аккаунтов пользователя
  Future<List<AccountEntity>> getAllAccounts();

  /// Метод обновления аккаунта
  Future<AccountEntity> updateAccount({
    required int id,
    required AccountUpdateRequestEntity request,
  });

  /// Метод получения категорий
  Future<List<CategoryEntity>> getAllCategories();

  /// Метод очистки базы данных
  Future<void> clearDatabase();

  /// Метод закрытия соединения с базой данных
  Future<void> close();
}
