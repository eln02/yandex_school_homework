import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yandex_school_homework/app/database/i_database_service.dart';
import 'package:yandex_school_homework/features/accounts/data/mock_data/accounts_mock_data.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_entity.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_update_request_entity.dart';
import 'package:yandex_school_homework/features/categories/data/mock_data/categories_mock_data.dart';
import 'package:yandex_school_homework/features/categories/domain/entity/category_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_request_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';
import 'database_mappers.dart';

class DatabaseService implements IDatabaseService {
  final String databaseName;
  final int databaseVersion;
  Database? _database;

  static const tableTransactions = 'transactions';
  static const tableCategories = 'categories';
  static const tableAccounts = 'accounts';

  DatabaseService({
    this.databaseName = 'finance_app.db',
    this.databaseVersion = 1,
  });

  Future<Database> get _db async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), databaseName);
    return await openDatabase(
      path,
      version: databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableCategories (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        emoji TEXT NOT NULL,
        isIncome INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableAccounts (
        id INTEGER PRIMARY KEY,
        userId INTEGER NOT NULL,
        name TEXT NOT NULL,
        balance TEXT NOT NULL,
        currency TEXT NOT NULL,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL
      )
    ''');

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

  Future<void> _insertInitialData(Database db) async {
    // Вставляем моковые категории
    for (final category in CategoriesMockData.categories) {
      await db.insert(tableCategories, category);
    }

    // Вставляем моковые аккаунты
    for (final account in AccountsMockData.accounts) {
      await db.insert(tableAccounts, {
        'id': account['id'],
        'userId': account['userId'],
        'name': account['name'],
        'balance': account['balance'],
        'currency': account['currency'],
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  @override
  Future<List<TransactionResponseEntity>> getAllTransactions({
    required int accountId,
    required String startDate,
    required String endDate,
  }) async {
    final db = await _db;

    final start = DateTime.parse(startDate).copyWith(
        hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
    final end = DateTime.parse(endDate).copyWith(
        hour: 23, minute: 59, second: 59, millisecond: 999, microsecond: 999);

    final transactions = await db.query(
      tableTransactions,
      where: 'accountId = ? AND transactionDate BETWEEN ? AND ?',
      whereArgs: [accountId, start.millisecondsSinceEpoch, end.millisecondsSinceEpoch],
      orderBy: 'transactionDate DESC',
    );

    final account = await _getAccount(db, accountId);
    final categories = await db.query(tableCategories);

    return transactions.map((t) {
      final category = categories.firstWhere(
            (c) => c['id'] == t['categoryId'],
      ).toCategoryEntity();

      return t.toTransactionEntity(account: account, category: category);
    }).toList();
  }

  @override
  Future<TransactionResponseEntity> createTransaction(
      TransactionRequestEntity request,
      ) async {
    final db = await _db;
    final now = DateTime.now();

    final account = await _getAccount(db, request.accountId);
    final category = await _getCategory(db, request.categoryId);
    final amount = double.parse(request.amount);
    final balanceChange = category.isIncome ? amount : -amount;

    final newBalance = (double.parse(account.balance) + balanceChange).toString();
    await _updateAccountBalance(db, account.id, newBalance);

    final transactionId = now.millisecondsSinceEpoch;
    final transactionMap = {
      'id': transactionId,
      'accountId': account.id,
      'categoryId': category.id,
      'amount': amount,
      'transactionDate': request.transactionDate.millisecondsSinceEpoch,
      'comment': request.comment,
      'createdAt': now.millisecondsSinceEpoch,
      'updatedAt': now.millisecondsSinceEpoch,
    };

    await db.insert(tableTransactions, transactionMap);

    return transactionMap.toTransactionEntity(
      account: account,
      category: category,
    );
  }

  @override
  Future<void> deleteTransaction(int id) async {
    final db = await _db;
    final transaction = await _getTransaction(db, id);
    final category = await _getCategory(db, transaction.categoryId);
    final account = await _getAccount(db, transaction.accountId);

    final balanceChange = category.isIncome
        ? -transaction.amount
        : transaction.amount;

    final newBalance = (double.parse(account.balance) + balanceChange).toString();
    await _updateAccountBalance(db, account.id, newBalance);

    await db.delete(
      tableTransactions,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<TransactionResponseEntity> updateTransaction({
    required int id,
    required TransactionRequestEntity request,
  }) async {
    final db = await _db;
    final now = DateTime.now();

    final oldTransaction = await _getTransaction(db, id);
    final oldCategory = await _getCategory(db, oldTransaction.categoryId);
    final account = await _getAccount(db, request.accountId);
    final newCategory = await _getCategory(db, request.categoryId);

    final oldAmount = oldTransaction.amount;
    final newAmount = double.parse(request.amount);

    final oldBalanceChange = oldCategory.isIncome ? -oldAmount : oldAmount;
    final newBalanceChange = newCategory.isIncome ? newAmount : -newAmount;
    final totalBalanceChange = oldBalanceChange + newBalanceChange;

    final newBalance = (double.parse(account.balance) + totalBalanceChange).toString();
    await _updateAccountBalance(db, account.id, newBalance);

    final updatedTransaction = {
      'id': id,
      'accountId': request.accountId,
      'categoryId': request.categoryId,
      'amount': newAmount,
      'transactionDate': request.transactionDate.millisecondsSinceEpoch,
      'comment': request.comment,
      'createdAt': oldTransaction.createdAt.millisecondsSinceEpoch,
      'updatedAt': now.millisecondsSinceEpoch,
    };

    await db.update(
      tableTransactions,
      updatedTransaction,
      where: 'id = ?',
      whereArgs: [id],
    );

    return updatedTransaction.toTransactionEntity(
      account: account,
      category: newCategory,
    );
  }

  /// Метод получения всех категорий
  @override
  Future<List<CategoryEntity>> getAllCategories() async {
    final db = await _db;
    final categories = await db.query(tableCategories);
    return categories.map((c) => c.toCategoryEntity()).toList();
  }

  @override
  Future<List<AccountEntity>> getAllAccounts() async {
    final db = await _db;
    final accounts = await db.query(tableAccounts);
    return accounts.map((a) => a.toAccountEntity()).toList();
  }

  @override
  Future<AccountEntity> updateAccount({
    required int id,
    required AccountUpdateRequestEntity request,
  }) async {
    final db = await _db;
    final now = DateTime.now();

    await db.update(
      tableAccounts,
      {
        'name': request.name,
        'balance': request.balance,
        'currency': request.currency,
        'updatedAt': now.millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [id],
    );

    return (await db.query(
      tableAccounts,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    )).first.toAccountEntity();
  }

  Future<AccountEntity> _getAccount(Database db, int id) async {
    final accounts = await db.query(
      tableAccounts,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return accounts.first.toAccountEntity();
  }

  Future<CategoryEntity> _getCategory(Database db, int id) async {
    final categories = await db.query(
      tableCategories,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return categories.first.toCategoryEntity();
  }

  Future<TransactionResponseEntity> _getTransaction(Database db, int id) async {
    final transaction = (await db.query(
      tableTransactions,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    )).first;

    return transaction.toTransactionEntity(
      account: await _getAccount(db, transaction['accountId'] as int),
      category: await _getCategory(db, transaction['categoryId'] as int),
    );
  }

  Future<void> _updateAccountBalance(Database db, int accountId, String newBalance) async {
    await db.update(
      tableAccounts,
      {
        'balance': newBalance,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [accountId],
    );
  }

  @override
  Future<void> clearDatabase() async {
    final db = await _db;
    await db.delete(tableTransactions);
    await db.delete(tableCategories);
    await db.delete(tableAccounts);
    await _insertInitialData(db);
  }

  @override
  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}