import 'package:yandex_school_homework/app/database/backup_operation.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_entity.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_update_request_entity.dart';
import 'package:yandex_school_homework/features/categories/domain/entity/category_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_request_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';

abstract class IDatabaseService {
  //----------------------------------------------------------------------------
  // Основные методы управления базой данных
  //----------------------------------------------------------------------------

  Future<void> clearDatabase();

  Future<void> close();

  //----------------------------------------------------------------------------
  // Методы для работы с бэкапом операций
  //----------------------------------------------------------------------------

  Future<void> addBackupOperation({
    required String operationType,
    required String entityType,
    required String entityId,
    required Map<String, dynamic> payload,
  });

  Future<List<BackupOperation>> getUnsyncedOperations(String entityType);

  Future<void> markAsSynced(List<String> operationIds);

  //----------------------------------------------------------------------------
  // Методы для работы с аккаунтами
  //----------------------------------------------------------------------------

  Future<List<AccountEntity>> getAllAccounts();

  Future<void> saveAccounts(List<AccountEntity> accounts);

  Future<AccountEntity> updateAccount({
    required int id,
    required AccountUpdateRequestEntity request,
  });

  //----------------------------------------------------------------------------
  // Методы для работы с категориями
  //----------------------------------------------------------------------------

  Future<List<CategoryEntity>> getAllCategories();

  Future<void> saveCategories(List<CategoryEntity> categories);

  //----------------------------------------------------------------------------
  // Методы для работы с транзакциями
  //----------------------------------------------------------------------------

  Future<List<TransactionResponseEntity>> getAllTransactions({
    required int accountId,
    required String startDate,
    required String endDate,
  });

  Future<void> saveTransactions(List<TransactionResponseEntity> transactions);

  Future<TransactionResponseEntity> createTransaction(
    TransactionRequestEntity request,
  );

  Future<TransactionResponseEntity> updateTransaction({
    required int id,
    required TransactionRequestEntity request,
  });

  Future<void> deleteTransaction(int id);

  Future<void> updateTransactionId({required int oldId, required int newId});
}
