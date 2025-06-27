import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_brief_entity.dart';
import 'package:yandex_school_homework/features/categories/domain/entity/category_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';

class DatabaseHelper {
  static const _databaseName = 'finance_app.db';
  static const _databaseVersion = 1;

  // Таблицы и колонки
  static const tableTransactions = 'transactions';
  static const tableCategories = 'categories';
  static const tableAccounts = 'accounts';

  // Singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    // Таблица категорий
    await db.execute('''
      CREATE TABLE $tableCategories (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        emoji TEXT NOT NULL,
        isIncome INTEGER NOT NULL
      )
    ''');

    // Таблица аккаунтов
    await db.execute('''
      CREATE TABLE $tableAccounts (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        balance TEXT NOT NULL,
        currency TEXT NOT NULL
      )
    ''');

    // Таблица транзакций
    await db.execute('''
      CREATE TABLE $tableTransactions (
        id INTEGER PRIMARY KEY,
        accountId INTEGER NOT NULL,
        categoryId INTEGER NOT NULL,
        amount REAL NOT NULL,
        transactionDate INTEGER NOT NULL,
        comment TEXT,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL,
        FOREIGN KEY (accountId) REFERENCES $tableAccounts (id),
        FOREIGN KEY (categoryId) REFERENCES $tableCategories (id)
      )
    ''');

    // Заполняем начальными данными
    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    // Основные категории расходов
    const expenseCategories = [
      {'id': 1, 'name': 'Food', 'emoji': '🍕', 'isIncome': 0},
      {'id': 2, 'name': 'Transport', 'emoji': '🚕', 'isIncome': 0},
      {'id': 3, 'name': 'Shopping', 'emoji': '🛍️', 'isIncome': 0},
    ];

    // Основные категории доходов
    const incomeCategories = [
      {'id': 4, 'name': 'Salary', 'emoji': '💰', 'isIncome': 1},
      {'id': 5, 'name': 'Gift', 'emoji': '🎁', 'isIncome': 1},
    ];

    // Добавляем категории
    for (var category in [...expenseCategories, ...incomeCategories]) {
      await db.insert(tableCategories, category);
    }

    // Основные аккаунты
    const accounts = [
      {'id': 1, 'name': 'Main Account', 'balance': 5000.0, 'currency': 'USD'},
      {'id': 2, 'name': 'Savings', 'balance': 10000.0, 'currency': 'USD'},
    ];

    // Добавляем аккаунты
    for (var account in accounts) {
      await db.insert(tableAccounts, account);
    }
  }

  // Transaction CRUD operations
  Future<int> insertTransaction(TransactionResponseEntity transaction) async {
    final db = await database;
    return await db.insert(tableTransactions, _transactionToMap(transaction));
  }

  Future<List<TransactionResponseEntity>> getAllTransactions() async {
    final db = await database;
    final transactions = await db.query(tableTransactions);
    final accounts = await db.query(tableAccounts);
    final categories = await db.query(tableCategories);

    return transactions.map((t) {
      final account = accounts.firstWhere((a) => a['id'] == t['accountId']);
      final category = categories.firstWhere((c) => c['id'] == t['categoryId']);

      return TransactionResponseEntity(
        id: t['id'] as int,
        account: AccountBriefEntity(
          id: account['id'] as int,
          name: account['name'] as String,
          balance: account['balance'] as String,
          currency: account['currency'] as String,
        ),
        category: CategoryEntity(
          id: category['id'] as int,
          name: category['name'] as String,
          emoji: category['emoji'] as String,
          isIncome: (category['isIncome'] as int) == 1,
        ),
        amount: t['amount'] as double,
        transactionDate: DateTime.fromMillisecondsSinceEpoch(t['transactionDate'] as int),
        comment: t['comment'] as String?,
        createdAt: DateTime.fromMillisecondsSinceEpoch(t['createdAt'] as int),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(t['updatedAt'] as int),
      );
    }).toList();
  }

  Map<String, dynamic> _transactionToMap(TransactionResponseEntity transaction) {
    return {
      'id': transaction.id,
      'accountId': transaction.account.id,
      'categoryId': transaction.category.id,
      'amount': transaction.amount,
      'transactionDate': transaction.transactionDate.millisecondsSinceEpoch,
      'comment': transaction.comment,
      'createdAt': transaction.createdAt.millisecondsSinceEpoch,
      'updatedAt': transaction.updatedAt.millisecondsSinceEpoch,
    };
  }

  // Для очистки базы (для отладки)
  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete(tableTransactions);
    await db.delete(tableCategories);
    await db.delete(tableAccounts);
    await _insertInitialData(db);
  }
}