import 'dart:math';

import 'package:flutter/material.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/features/common/ui/custom_app_bar.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_request_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';
import 'package:yandex_school_homework/features/transactions/presentation/componenets/transactions_list.dart';

/// Тестовый экран для демонстрации работы базы данных
/// да, тут сервис прям в ui вызывается. Не надо ревьюить))
class TransactionsDebugScreen extends StatefulWidget {
  const TransactionsDebugScreen({super.key});

  @override
  State<TransactionsDebugScreen> createState() =>
      _TransactionsDebugScreenState();
}

class _TransactionsDebugScreenState extends State<TransactionsDebugScreen> {
  List<TransactionResponseEntity> _transactions = [];
  bool _isLoading = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    if (!mounted) return;

    setState(() => _isLoading = true);
    try {
      final transactions = await context.di.databaseService
          .getAllTransactions();
      transactions.sort(
        (a, b) => b.transactionDate.compareTo(a.transactionDate),
      );
      if (mounted) {
        setState(() => _transactions = transactions);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _addTransaction() async {
    final request = TransactionRequestEntity(
      accountId: 140,
      categoryId: 1 + Random().nextInt(24),
      amount: (Random().nextDouble() * 1000).toString(),
      transactionDate: DateTime.now(),
      comment: UniqueKey().toString(),
    );

    final transaction = await context.di.databaseService.createTransaction(
      request,
    );

    setState(() {
      _transactions.insert(0, transaction);
    });
  }

  Future<void> _clearDatabase() async {
    await context.di.databaseService.clearDatabase();
    _refreshIndicatorKey.currentState?.show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Экран теста DatabaseService',
        icon: const Icon(Icons.delete),
        onNext: _clearDatabase,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _addTransaction(),
            child: const Text('Сгенерировать транзакцию'),
          ),
          Expanded(
            child: _isLoading && _transactions.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: _loadTransactions,
                    child: _transactions.isEmpty
                        ? const Center(child: Text('Пока нет транзакций'))
                        : TransactionsList(
                            transactions: _transactions,
                            onRefresh: _loadTransactions,
                          ),
                  ),
          ),
        ],
      ),
    );
  }
}
