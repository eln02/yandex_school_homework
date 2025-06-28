import 'package:yandex_school_homework/di/di_base_repo.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_request_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';

abstract interface class ITransactionsRepository with DiBaseRepo {
  Future<TransactionResponseEntity> fetchTransactionById(int id);

  Future<List<TransactionResponseEntity>> fetchTransactionsByPeriod({
    required int accountId,
    required String startDate,
    required String endDate,
  });

  Future<TransactionResponseEntity> createTransaction(
    TransactionRequestEntity transaction,
  );

  Future<TransactionResponseEntity> updateTransaction({
    required TransactionRequestEntity transaction,
    required int id,
  });

  Future<void> deleteTransactionById(int id);
}
