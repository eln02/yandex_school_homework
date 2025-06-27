import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';

abstract class IDatabaseService {
  /// Метод добавления транзакции
  Future<int> insertTransaction(TransactionResponseEntity transaction);

  /// Метод получения всех транзакций
  Future<List<TransactionResponseEntity>> getAllTransactions();

  /// Метод очистки базы данных
  Future<void> clearDatabase();

  Future<void> close();
}
