import 'package:flutter/material.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_brief_entity.dart';
import 'package:yandex_school_homework/features/categories/domain/entity/category_entity.dart';
import 'package:yandex_school_homework/features/transactions/data/database/database_helper.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';
import 'package:yandex_school_homework/features/transactions/presentation/componenets/transactions_list.dart';

class TransactionsDebugScreen extends StatefulWidget {
  const TransactionsDebugScreen({super.key});

  @override
  State<TransactionsDebugScreen> createState() =>
      _TransactionsDebugScreenState();
}

class _TransactionsDebugScreenState extends State<TransactionsDebugScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<TransactionResponseEntity> _transactions = [];
  bool _isLoading = false;
  List<Map<String, dynamic>> _accounts = [];
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);

    final db = await _dbHelper.database;
    _accounts = await db.query(DatabaseHelper.tableAccounts);
    _categories = await db.query(DatabaseHelper.tableCategories);

    await _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final transactions = await _dbHelper.getAllTransactions();
    setState(() {
      _transactions = transactions;
      _isLoading = false;
    });
  }

  Future<void> _addTestTransaction(bool isIncome) async {
    if (_accounts.isEmpty || _categories.isEmpty) return;

    final now = DateTime.now();
    final category = _categories.firstWhere(
      (c) => (c['isIncome'] as int) == (isIncome ? 1 : 0),
      orElse: () => _categories.first,
    );

    final testTransaction = TransactionResponseEntity(
      id: now.millisecondsSinceEpoch,
      account: AccountBriefEntity(
        id: _accounts.first['id'] as int,
        name: _accounts.first['name'] as String,
        balance: _accounts.first['balance'] as String,
        currency: _accounts.first['currency'] as String,
      ),
      category: CategoryEntity(
        id: category['id'] as int,
        name: category['name'] as String,
        emoji: category['emoji'] as String,
        isIncome: (category['isIncome'] as int) == 1,
      ),
      amount: isIncome ? 500.0 : 100.0,
      transactionDate: now,
      comment: isIncome ? 'Monthly salary' : 'Grocery shopping',
      createdAt: now,
      updatedAt: now,
    );

    await _dbHelper.insertTransaction(testTransaction);
    await _loadTransactions();
  }

  Future<void> _clearDatabase() async {
    await _dbHelper.clearDatabase();
    await _loadInitialData();
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                  child: _transactions.isEmpty
                      ? const Center(child: Text('No transactions yet'))
                      : TransactionsList(
                          transactions: _transactions,
                          onRefresh: _loadTransactions,
                        ),
                ),
              ],
            ),
    );
  }
}
