import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:yandex_school_homework/app/database/i_database_service.dart';
import 'package:yandex_school_homework/features/accounts/data/mock_data/accounts_mock_data.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_brief_entity.dart';
import 'package:yandex_school_homework/features/categories/data/mock_data/categories_mock_data.dart';
import 'package:yandex_school_homework/features/categories/domain/entity/category_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_request_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';

/// Сервис для работы с базой данных
class DatabaseService implements IDatabaseService {
  final String databaseName;
  final int databaseVersion;
  Database? _database;

  // Таблицы и колонки
  static const tableTransactions = 'transactions';
  static const tableCategories = 'categories';
  static const tableAccounts = 'accounts';

  DatabaseService({
    this.databaseName = 'finance_app.db',
    this.databaseVersion = 1,
  });

  Future<Database> get _db async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Иницаилизация базы данных
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), databaseName);
    return await openDatabase(
      path,
      version: databaseVersion,
      onCreate: _onCreate,
    );
  }

  /// Метод для создания таблиц
  Future _onCreate(Database db, int version) async {
    /// Таблица категорий (соответствует сущности CategoryEntity)
    await db.execute('''
      CREATE TABLE $tableCategories (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        emoji TEXT NOT NULL,
        isIncome INTEGER NOT NULL
      )
    ''');

    /// Таблица аккаунтов (соответствует сущности AccountBriefEntity)
    await db.execute('''
      CREATE TABLE $tableAccounts (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        balance TEXT NOT NULL,
        currency TEXT NOT NULL
      )
    ''');

    /// Таблица транзакций (соответствует сущности TransactionEntity)
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

    await _insertInitialData(db);
  }

  /// Метод добавления данных категорий и аккаунтов из моковых данных
  // TODO: сделать при инициализации заполнение реальными данными из апи
  Future<void> _insertInitialData(Database db) async {
    // Моковые данные
    final categories = CategoriesMockData.categories;
    final accounts = AccountsMockData.briefAccounts;

    // Добавляем категории
    for (var category in categories) {
      await db.insert(tableCategories, category);
    }

    // Добавляем аккаунты
    for (var account in accounts) {
      await db.insert(tableAccounts, account);
    }
  }

  /// Метод получения всех транзакций
  /// Связанные сущности аккаунта и категории подтягиваются по id
  @override
  Future<List<TransactionResponseEntity>> getAllTransactions() async {
    final db = await _db;
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
        transactionDate: DateTime.fromMillisecondsSinceEpoch(
          t['transactionDate'] as int,
        ),
        comment: t['comment'] as String?,
        createdAt: DateTime.fromMillisecondsSinceEpoch(t['createdAt'] as int),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(t['updatedAt'] as int),
      );
    }).toList();
  }

  /// Метод создания транзакции
  /// Связанные сущности аккаунта и категории подтягиваются по id
  @override
  Future<TransactionResponseEntity> createTransaction(
    TransactionRequestEntity request,
  ) async {
    final db = await _db;

    // Получаем аккаунт из базы
    final accounts = await db.query(
      'accounts',
      where: 'id = ?',
      whereArgs: [request.accountId],
      limit: 1,
    );
    if (accounts.isEmpty) throw Exception('Account not found');

    // Получаем категорию из базы
    final categories = await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [request.categoryId],
      limit: 1,
    );
    if (categories.isEmpty) throw Exception('Category not found');

    // Создаем TransactionResponseEntity
    final now = DateTime.now();
    final transaction = TransactionResponseEntity(
      id: now.millisecondsSinceEpoch,
      account: AccountBriefEntity(
        id: accounts.first['id'] as int,
        name: accounts.first['name'] as String,
        balance: accounts.first['balance'] as String,
        currency: accounts.first['currency'] as String,
      ),
      category: CategoryEntity(
        id: categories.first['id'] as int,
        name: categories.first['name'] as String,
        emoji: categories.first['emoji'] as String,
        isIncome: (categories.first['isIncome'] as int) == 1,
      ),
      amount: double.parse(request.amount),
      transactionDate: request.transactionDate,
      comment: request.comment,
      createdAt: now,
      updatedAt: now,
    );

    // Сохраняем в базу
    await db.insert('transactions', {
      'id': transaction.id,
      'accountId': transaction.account.id,
      'categoryId': transaction.category.id,
      'amount': transaction.amount,
      'transactionDate': transaction.transactionDate.millisecondsSinceEpoch,
      'comment': transaction.comment,
      'createdAt': transaction.createdAt.millisecondsSinceEpoch,
      'updatedAt': transaction.updatedAt.millisecondsSinceEpoch,
    });

    return transaction;
  }

  /// Метод очистки базы данных
  @override
  Future<void> clearDatabase() async {
    final db = await _db;
    await db.delete(tableTransactions);
    await db.delete(tableCategories);
    await db.delete(tableAccounts);
    await _insertInitialData(db);
  }

  /// Метод закрытия соединения с базой данных
  @override
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
