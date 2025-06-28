import 'package:yandex_school_homework/app/http/i_http_client.dart';
import 'package:yandex_school_homework/features/transactions/data/dto/transaction_request/transaction_request_dto_mapper.dart';
import 'package:yandex_school_homework/features/transactions/data/dto/transaction_response/transaction_response_dto.dart';
import 'package:yandex_school_homework/features/transactions/data/dto/transaction_response/transaction_response_dto_mapper.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_request_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/repository/i_transactions_repository.dart';

final class TransactionsRepository implements ITransactionsRepository {
  TransactionsRepository({required this.httpClient});

  final IHttpClient httpClient;

  @override
  String get name => 'TransactionsRepository';

  static const String transactions = 'transactions';

  @override
  Future<TransactionResponseEntity> fetchTransactionById(int id) async {
    final response = await httpClient.get('$transactions/$id');
    final Map<String, dynamic> data = response.data;
    return TransactionResponseDto.fromJson(data).toEntity();
  }

  @override
  Future<void> deleteTransactionById(int id) async {
    await httpClient.delete('$transactions/$id');
  }

  @override
  Future<TransactionResponseEntity> createTransaction(
    TransactionRequestEntity transaction,
  ) async {
    final response = await httpClient.post(
      transactions,
      data: TransactionRequestDtoMapper.fromEntity(transaction).toJson(),
    );
    final id = (response.data as Map<String, dynamic>)['id'];
    final data = await fetchTransactionById(id);
    return data;
  }

  @override
  Future<TransactionResponseEntity> updateTransaction({
    required TransactionRequestEntity transaction,
    required int id,
  }) async {
    final response = await httpClient.put(
      '$transactions/$id',
      data: TransactionRequestDtoMapper.fromEntity(transaction).toJson(),
    );
    final Map<String, dynamic> data = response.data;
    return TransactionResponseDto.fromJson(data).toEntity();
  }

  @override
  Future<List<TransactionResponseEntity>> fetchTransactionsByPeriod({
    required int accountId,
    required String startDate,
    required String endDate,
  }) async {
    final response = await httpClient.get(
      '$transactions/account/$accountId/period',
      queryParameters: {'startDate': startDate, 'endDate': endDate},
    );

    final List<dynamic> data = response.data;
    return (data)
        .map((item) => TransactionResponseDto.fromJson(item).toEntity())
        .toList();
  }
}
