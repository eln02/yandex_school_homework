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

  /// Метод очистки базы данных
  Future<void> clearDatabase();

  /// Метод закрытия соединения с базой данных
  Future<void> close();
}
