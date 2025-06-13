import 'package:yandex_school_homework/features/transactions/data/dto/transaction/transaction_dto.dart';
import 'package:yandex_school_homework/features/transactions/data/dto/transaction/transaction_dto_mapper.dart';
import 'package:yandex_school_homework/features/transactions/data/dto/transaction_response/transaction_response_dto.dart';
import 'package:yandex_school_homework/features/transactions/data/dto/transaction_response/transaction_response_dto_mapper.dart';
import 'package:yandex_school_homework/features/transactions/data/mock_data/transactions_mock_data.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_request_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/repository/i_transactions_repository.dart';

final class TransactionsMockRepository implements ITransactionsRepository {
  @override
  String get name => 'TransactionsMockRepository';

  @override
  Future<TransactionResponseEntity> fetchTransactionById(int id) async {
    await Future.delayed(const Duration(seconds: 1));
    final Map<String, dynamic> transaction =
        TransactionsMockData.transactionResponse;

    return TransactionResponseDto.fromJson(transaction).toEntity();
  }

  @override
  Future<void> deleteTransactionById(int id) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<TransactionEntity> createTransaction(
    TransactionRequestEntity transaction,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    final Map<String, dynamic> transaction = TransactionsMockData.transaction;

    return TransactionDto.fromJson(transaction).toEntity();
  }

  @override
  Future<TransactionResponseEntity> updateTransaction({
    required TransactionRequestEntity transaction,
    required int id,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    final Map<String, dynamic> transaction =
        TransactionsMockData.transactionResponse;

    return TransactionResponseDto.fromJson(transaction).toEntity();
  }
}
