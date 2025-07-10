import 'package:yandex_school_homework/features/transactions/data/dto/transaction_response/transaction_response_dto.dart';
import 'package:yandex_school_homework/features/transactions/data/dto/transaction_response/transaction_response_dto_mapper.dart';
import 'package:yandex_school_homework/features/transactions/data/mock_data/transactions_mock_data.dart';
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
        TransactionsMockData.transactions[0];

    return TransactionResponseDto.fromJson(transaction).toEntity();
  }

  @override
  Future<void> deleteTransactionById(int id) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<TransactionResponseEntity> createTransaction(
    TransactionRequestEntity transaction,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    final Map<String, dynamic> transaction =
        TransactionsMockData.transactions[0];

    return TransactionResponseDto.fromJson(transaction).toEntity();
  }

  @override
  Future<TransactionResponseEntity> updateTransaction({
    required TransactionRequestEntity transaction,
    required int id,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    final Map<String, dynamic> transaction =
        TransactionsMockData.transactions[0];

    return TransactionResponseDto.fromJson(transaction).toEntity();
  }

  @override
  Future<List<TransactionResponseEntity>> fetchTransactionsByPeriod({
    required int accountId,
    required String startDate,
    required String endDate,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final start = DateTime.parse(startDate);
    final end = DateTime.parse(endDate);

    final filtered = TransactionsMockData.transactions.where((transaction) {
      if ((transaction['account'] as Map<String, dynamic>?)?['id'] !=
          accountId) {
        return false;
      }
      final transactionDate = DateTime.parse(
        transaction['transactionDate'] as String,
      );
      if (transactionDate.isBefore(start)) return false;
      if (transactionDate.isAfter(end)) return false;
      return true;
    }).toList();

    return filtered
        .map((json) => TransactionResponseDto.fromJson(json).toEntity())
        .toList();
  }

  @override
  Future<void> syncPendingChanges() {
    // TODO: implement syncPendingChanges
    throw UnimplementedError();
  }
}
