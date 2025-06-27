import 'package:flutter/material.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_brief_entity.dart';
import 'package:yandex_school_homework/features/categories/domain/entity/category_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';
import 'package:yandex_school_homework/features/transactions/presentation/componenets/transactions_list.dart';

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
      // Сортируем по дате в обратном порядке (новые сверху)
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

  Future<void> _addTestTransaction(bool isIncome) async {
    final now = DateTime.now();
    final testTransaction = TransactionResponseEntity(
      id: now.millisecondsSinceEpoch,
      account: AccountBriefEntity(
        id: 1,
        name: 'Main Account',
        balance: '5000.0',
        currency: 'USD',
      ),
      category: CategoryEntity(
        id: isIncome ? 4 : 1,
        name: isIncome ? 'Salary' : 'Food',
        emoji: isIncome ? '💰' : '🍕',
        isIncome: isIncome,
      ),
      amount: isIncome ? 500.0 : 100.0,
      transactionDate: now,
      comment: isIncome ? 'Monthly salary' : 'Grocery shopping',
      createdAt: now,
      updatedAt: now,
    );

    await context.di.databaseService.insertTransaction(testTransaction);

    // Оптимизированное обновление - добавляем новую транзакцию в начало списка
    if (mounted) {
      setState(() {
        _transactions.insert(0, testTransaction);
      });
    }
  }

  Future<void> _clearDatabase() async {
    await context.di.databaseService.clearDatabase();
    _refreshIndicatorKey.currentState?.show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions Debug'),
        actions: [
          IconButton(icon: const Icon(Icons.delete), onPressed: _clearDatabase),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _addTestTransaction(false),
                child: const Text('Add Expense'),
              ),
              ElevatedButton(
                onPressed: () => _addTestTransaction(true),
                child: const Text('Add Income'),
              ),
            ],
          ),
          Expanded(
            child: _isLoading && _transactions.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: _loadTransactions,
                    child: _transactions.isEmpty
                        ? const Center(child: Text('No transactions yet'))
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
