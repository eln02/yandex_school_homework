import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yandex_school_homework/app/database/backup_operation.dart';
import 'package:yandex_school_homework/app/database/i_database_service.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_entity.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_update_request_entity.dart';
import 'package:yandex_school_homework/features/categories/domain/entity/category_entity.dart';
import 'package:yandex_school_homework/features/debug/i_debug_service.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_request_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';
import 'database_mappers.dart';

/// Сервис для работы с локальной базой данных SQLite.
/// Реализует offline-first подход с поддержкой бэкапа операций.
class DatabaseService implements IDatabaseService {
  final IDebugService debugService;
  final String databaseName;
  final int databaseVersion;
  Database? _database;

  // Названия таблиц
  static const tableTransactions = 'transactions';
  static const tableCategories = 'categories';
  static const tableAccounts = 'accounts';

  /// Создает экземпляр DatabaseService.
  ///
  /// Параметры:
  /// - [databaseName] - имя файла базы данных (по умолчанию 'finance_app.db')
  /// - [databaseVersion] - версия базы данных (по умолчанию 1)
  DatabaseService({
    this.databaseName = 'finance_app.db',
    this.databaseVersion = 1,
    required this.debugService,
  });

  //----------------------------------------------------------------------------
  // Основные методы управления базой данных
  //----------------------------------------------------------------------------

  /// Возвращает экземпляр базы данных, инициализируя его при первом вызове.
  Future<Database> get _db async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// Инициализирует базу данных.
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), databaseName);
    return await openDatabase(
      path,
      version: databaseVersion,
      onCreate: _onCreate,
    );
  }

  /// Создает структуру базы данных при первом запуске.
  Future<void> _onCreate(Database db, int version) async {
    // Таблица категорий
    await db.execute('''
      CREATE TABLE $tableCategories (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        emoji TEXT NOT NULL,
        isIncome INTEGER NOT NULL
      )
    ''');

    // Таблица счетов
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

    // Таблица для хранения несинхронизированных операций
    await db.execute('''
      CREATE TABLE backup_operations (
        id TEXT PRIMARY KEY,
        operation_type TEXT NOT NULL,  -- 'CREATE'|'UPDATE'|'DELETE'
        entity_type TEXT NOT NULL,     -- 'transaction'|'account'|'category'
        entity_id TEXT NOT NULL,       -- ID сущности
        payload TEXT NOT NULL,         -- JSON с данными
        created_at INTEGER NOT NULL,   -- timestamp
        is_synced INTEGER DEFAULT 0    -- 0/1 (false/true)
      )
    ''');
  }

  /// Очищает все таблицы базы данных.
  @override
  Future<void> clearDatabase() async {
    final db = await _db;
    await db.delete(tableTransactions);
    await db.delete(tableCategories);
    await db.delete(tableAccounts);
  }

  /// Закрывает соединение с базой данных.
  @override
  Future<void> close() async {
    await _database?.close();
    _database = null;
  }

  //----------------------------------------------------------------------------
  // Методы для работы с бэкапом операций
  //----------------------------------------------------------------------------

  /// Добавляет операцию в бэкап для последующей синхронизации.
  ///
  /// Параметры:
  /// - [operationType] - тип операции ('CREATE', 'UPDATE' или 'DELETE')
  /// - [entityType] - тип сущности ('transaction', 'account' или 'category')
  /// - [entityId] - ID сущности
  /// - [payload] - данные операции в формате Map
  @override
  Future<void> addBackupOperation({
    required String operationType,
    required String entityType,
    required String entityId,
    required Map<String, dynamic> payload,
  }) async {
    final db = await _db;
    try {
      await db.insert('backup_operations', {
        'id': DateTime.now().microsecondsSinceEpoch.toString(),
        'operation_type': operationType,
        'entity_type': entityType,
        'entity_id': entityId,
        'payload': jsonEncode(payload),
        'created_at': DateTime.now().millisecondsSinceEpoch,
        'is_synced': 0,
      });

      debugService.log(
        'Операция добавлена в бэкап, type: $operationType, entity: $entityType, payload: $payload',
      );
    } catch (e, stackTrace) {
      debugService.logError(
        'Ошибка при добавлении операции в бэкап, type: $operationType, entity: $entityType, payload: $payload',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Возвращает список несинхронизированных операций для указанного типа сущности.
  ///
  /// Параметры:
  /// - [entityType] - тип сущности ('transaction', 'account' или 'category')
  @override
  Future<List<BackupOperation>> getUnsyncedOperations(String entityType) async {
    final db = await _db;
    final operations = await db.query(
      'backup_operations',
      where: 'is_synced = ? AND entity_type = ?',
      whereArgs: [0, entityType],
    );

    return operations
        .map(
          (op) => BackupOperation(
            id: op['id'] as String,
            operationType: op['operation_type'] as String,
            entityType: op['entity_type'] as String,
            entityId: op['entity_id'] as String,
            payload: jsonDecode(op['payload'] as String),
            createdAt: DateTime.fromMillisecondsSinceEpoch(
              op['created_at'] as int,
            ),
            isSynced: op['is_synced'] == 1,
          ),
        )
        .toList();
  }

  /// Помечает операции как синхронизированные.
  ///
  /// Параметры:
  /// - [operationIds] - список ID операций для пометки как синхронизированные
  @override
  Future<void> markAsSynced(List<String> operationIds) async {
    final db = await _db;
    try {
      await db.update(
        'backup_operations',
        {'is_synced': 1},
        where: 'id IN (${operationIds.map((_) => '?').join(',')})',
        whereArgs: operationIds,
      );

      debugService.log(
        'Операции синхронизированы, кол-во: ${operationIds.length}',
      );
    } catch (e, stackTrace) {
      debugService.logError(
        'Ошибка при синхронизации операций',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  //----------------------------------------------------------------------------
  // Методы для работы с аккаунтами
  //----------------------------------------------------------------------------

  /// Возвращает список всех аккаунтов из локальной базы.
  ///
  /// Выбрасывает исключение, если аккаунты не найдены.
  @override
  Future<List<AccountEntity>> getAllAccounts() async {
    final db = await _db;
    final accounts = await db.query(tableAccounts);

    if (accounts.isEmpty) {
      throw Exception('Нет доступных счетов. Пожалуйста, создайте новый счёт.');
    }

    return accounts.map((a) => a.toAccountEntity()).toList();
  }

  /// Сохраняет список аккаунтов в локальную базу.
  ///
  /// Параметры:
  /// - [accounts] - список аккаунтов для сохранения
  @override
  Future<void> saveAccounts(List<AccountEntity> accounts) async {
    final db = await _db;
    try {
      await db.transaction((txn) async {
        for (final account in accounts) {
          await txn.insert(
            tableAccounts,
            account.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });

      debugService.log(
        'Аккаунты сохранены в базу данных, кол-во: ${accounts.length}',
      );
    } catch (e, stackTrace) {
      debugService.logError(
        'Ошибка при сохранении аккаунтов',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Обновляет данные аккаунта в локальной базе.
  ///
  /// Параметры:
  /// - [id] - ID аккаунта для обновления
  /// - [request] - данные для обновления
  ///
  /// Выбрасывает исключение, если аккаунт не найден.
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

    final updatedAccount = await db.query(
      tableAccounts,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (updatedAccount.isEmpty) {
      throw Exception('Не удалось обновить счёт: счёт с ID $id не найден');
    }

    return updatedAccount.first.toAccountEntity();
  }

  //----------------------------------------------------------------------------
  // Методы для работы с категориями
  //----------------------------------------------------------------------------

  /// Возвращает список всех категорий из локальной базы.
  ///
  /// Выбрасывает исключение, если категории не найдены.
  @override
  Future<List<CategoryEntity>> getAllCategories() async {
    final db = await _db;
    final categories = await db.query(tableCategories);

    if (categories.isEmpty) {
      throw Exception(
        'Категории не найдены. Пожалуйста, синхронизируйте данные.',
      );
    }

    return categories.map((c) => c.toCategoryEntity()).toList();
  }

  /// Сохраняет список категорий в локальную базу, предварительно очищая старые данные.
  ///
  /// Параметры:
  /// - [categories] - список категорий для сохранения
  @override
  Future<void> saveCategories(List<CategoryEntity> categories) async {
    final db = await _db;

    try {
      await db.transaction((txn) async {
        for (final category in categories) {
          final categoryData = {
            'id': category.id,
            'name': category.name,
            'emoji': category.emoji,
            'isIncome': category.isIncome ? 1 : 0,
          };

          await txn.insert(
            tableCategories,
            categoryData,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        debugService.log(
          'Категории сохранены в базу данных, кол-во: ${categories.length}',
        );
      });
    } catch (e, stackTrace) {
      debugService.logError(
        'Ошибка сохранения категорий',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  //----------------------------------------------------------------------------
  // Методы для работы с транзакциями
  //----------------------------------------------------------------------------

  /// Возвращает список транзакций за указанный период для конкретного счета.
  ///
  /// Параметры:
  /// - [accountId] - ID счета
  /// - [startDate] - начальная дата периода (формат 'yyyy-mm-dd')
  /// - [endDate] - конечная дата периода (формат 'yyyy-mm-dd')
  @override
  Future<List<TransactionResponseEntity>> getAllTransactions({
    required int accountId,
    required String startDate,
    required String endDate,
  }) async {
    final db = await _db;

    final start = DateTime.parse(
      startDate,
    ).copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
    final end = DateTime.parse(endDate).copyWith(
      hour: 23,
      minute: 59,
      second: 59,
      millisecond: 999,
      microsecond: 999,
    );

    final transactions = await db.query(
      tableTransactions,
      where: 'accountId = ? AND transactionDate BETWEEN ? AND ?',
      whereArgs: [
        accountId,
        start.millisecondsSinceEpoch,
        end.millisecondsSinceEpoch,
      ],
      orderBy: 'transactionDate DESC',
    );

    final account = await _getAccount(db, accountId);
    final categories = await db.query(tableCategories);

    return transactions.map((t) {
      final category = categories
          .firstWhere((c) => c['id'] == t['categoryId'])
          .toCategoryEntity();

      return t.toTransactionEntity(account: account, category: category);
    }).toList();
  }

  /// Сохраняет список транзакций в локальную базу, предварительно очищая старые данные.
  ///
  /// Параметры:
  /// - [transactions] - список транзакций для сохранения
  @override
  Future<void> saveTransactions(
    List<TransactionResponseEntity> transactions,
  ) async {
    final db = await _db;
    try {
      await db.transaction((txn) async {
        await txn.delete(tableTransactions);

        for (final transaction in transactions) {
          await txn.insert(tableTransactions, {
            'id': transaction.id,
            'accountId': transaction.account.id,
            'categoryId': transaction.category.id,
            'amount': transaction.amount,
            'transactionDate':
                transaction.transactionDate.millisecondsSinceEpoch,
            'comment': transaction.comment,
            'createdAt': transaction.createdAt.millisecondsSinceEpoch,
            'updatedAt': transaction.updatedAt.millisecondsSinceEpoch,
          }, conflictAlgorithm: ConflictAlgorithm.replace);
        }
      });

      debugService.log(
        'Транзакции сохранены в базу данных, кол-во: ${transactions.length}',
      );
    } catch (e, stackTrace) {
      debugService.logError(
        'Ошибка при сохранении транзакций',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Создает новую транзакцию в локальной базе.
  ///
  /// Параметры:
  /// - [request] - данные для создания транзакции
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

    final newBalance = (double.parse(account.balance) + balanceChange)
        .toString();
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

  /// Обновляет существующую транзакцию в локальной базе.
  ///
  /// Параметры:
  /// - [id] - ID транзакции для обновления
  /// - [request] - новые данные транзакции
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

    final newBalance = (double.parse(account.balance) + totalBalanceChange)
        .toString();
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

  /// Удаляет транзакцию из локальной базы.
  ///
  /// Параметры:
  /// - [id] - ID транзакции для удаления
  @override
  Future<void> deleteTransaction(int id) async {
    final db = await _db;
    final transaction = await _getTransaction(db, id);
    final category = await _getCategory(db, transaction.categoryId);
    final account = await _getAccount(db, transaction.accountId);

    final balanceChange = category.isIncome
        ? -transaction.amount
        : transaction.amount;

    final newBalance = (double.parse(account.balance) + balanceChange)
        .toString();
    await _updateAccountBalance(db, account.id, newBalance);

    await db.delete(tableTransactions, where: 'id = ?', whereArgs: [id]);
  }

  /// Обновляет ID транзакции в локальной базе и бэкап операциях.
  ///
  /// Параметры:
  /// - [oldId] - старый ID транзакции
  /// - [newId] - новый ID транзакции
  @override
  Future<void> updateTransactionId({
    required int oldId,
    required int newId,
  }) async {
    final db = await _db;

    await db.transaction((txn) async {
      // Обновляем ID в таблице транзакций
      await txn.update(
        tableTransactions,
        {'id': newId},
        where: 'id = ?',
        whereArgs: [oldId],
      );

      // Обновляем ID в бэкап операциях
      await txn.update(
        'backup_operations',
        {'entity_id': newId.toString()},
        where: 'entity_type = ? AND entity_id = ?',
        whereArgs: ['transaction', oldId.toString()],
      );
    });
  }

  //----------------------------------------------------------------------------
  // Приватные вспомогательные методы
  //----------------------------------------------------------------------------

  /// Возвращает аккаунт по ID.
  ///
  /// Выбрасывает исключение, если аккаунт не найден.
  Future<AccountEntity> _getAccount(Database db, int id) async {
    final accounts = await db.query(
      tableAccounts,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (accounts.isEmpty) {
      throw Exception('Счёт с ID $id не найден в локальном хранилище');
    }

    return accounts.first.toAccountEntity();
  }

  /// Возвращает категорию по ID.
  ///
  /// Выбрасывает исключение, если категория не найдена.
  Future<CategoryEntity> _getCategory(Database db, int id) async {
    final categories = await db.query(
      tableCategories,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (categories.isEmpty) {
      throw Exception('Категория с ID $id не найдена в локальном хранилище');
    }

    return categories.first.toCategoryEntity();
  }

  /// Возвращает транзакцию по ID.
  ///
  /// Выбрасывает исключение, если транзакция не найдена.
  Future<TransactionResponseEntity> _getTransaction(Database db, int id) async {
    final transactions = await db.query(
      tableTransactions,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (transactions.isEmpty) {
      throw Exception('Транзакция с ID $id не найдена');
    }

    final account = await _getAccount(
      db,
      transactions.first['accountId'] as int,
    );
    final category = await _getCategory(
      db,
      transactions.first['categoryId'] as int,
    );

    return transactions.first.toTransactionEntity(
      account: account,
      category: category,
    );
  }

  /// Обновляет баланс аккаунта.
  ///
  /// Параметры:
  /// - [db] - экземпляр базы данных
  /// - [accountId] - ID аккаунта
  /// - [newBalance] - новое значение баланса
  Future<void> _updateAccountBalance(
    Database db,
    int accountId,
    String newBalance,
  ) async {
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
}
