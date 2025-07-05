import 'package:flutter/material.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_request_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';

/// ChangeNotifier для формы создания/редактирования транзакции
class TransactionNotifier extends ChangeNotifier {
  /// Транзакция для редактирования
  final TransactionResponseEntity? originalTransaction;

  int? _accountId;
  int? _categoryId;
  String _amount;
  DateTime _transactionDate;
  String? _comment;
  final bool? _isIncome;

  /// Конструктор для редактирования существующей транзакции
  /// Берет состояние всех полей из переданной транзакции
  TransactionNotifier.edit(this.originalTransaction)
    : _accountId = originalTransaction?.account.id,
      _categoryId = originalTransaction?.category.id,
      _amount = originalTransaction?.amount.toString() ?? '',
      _transactionDate =
          originalTransaction?.transactionDate ?? DateTime.now().toUtc(),
      _comment = originalTransaction?.comment,
      _isIncome = originalTransaction?.category.isIncome;

  /// Конструктор для создания новой транзакции
  /// Заполняется дефолтными значениями
  TransactionNotifier.create({bool? isIncome})
    : originalTransaction = null,
      _accountId = null,
      _categoryId = null,
      _amount = '',
      _transactionDate = DateTime.now().toUtc(),
      _comment = null,
      _isIncome = isIncome;

  /// Геттеры для получения полей

  int? get accountId => _accountId;

  int? get categoryId => _categoryId;

  String get amount => _amount;

  DateTime get transactionDate => _transactionDate.toLocal();

  String? get comment => _comment;

  bool? get isIncome => _isIncome;

  /// Геттер-дебаунс чтобы не отправлять запрос при отсутствии изменений
  bool get hasChanges {
    if (originalTransaction == null) {
      return true;
    }

    return _accountId != originalTransaction!.account.id ||
        _categoryId != originalTransaction!.category.id ||
        _amount != originalTransaction!.amount.toString() ||
        _transactionDate != originalTransaction!.transactionDate ||
        _comment != originalTransaction!.comment;
  }

  /// Методы обновления полей

  void updateAccount(int? id) {
    _accountId = id;
    notifyListeners();
  }

  void updateCategory(int? id) {
    _categoryId = id;
    notifyListeners();
  }

  void updateAmount(String value) {
    _amount = value;
    notifyListeners();
  }

  void updateDate(DateTime date) {
    _transactionDate = date;
    notifyListeners();
  }

  void updateComment(String? value) {
    _comment = value;
    notifyListeners();
  }

  /// Метод валидации формы
  List<String> validateForm() {
    final errors = <String>[];
    if (_accountId == null) errors.add('Выберите счет');
    if (_categoryId == null) errors.add('Выберите категорию');
    if (_amount.isEmpty) errors.add('Введите сумму');
    return errors;
  }

  /// Метод создания сущности транзакции для запроса
  TransactionRequestEntity? buildRequest() {
    if (validateForm().isNotEmpty) return null;
    return TransactionRequestEntity(
      accountId: _accountId!,
      categoryId: _categoryId!,
      amount: _amount,
      transactionDate: _transactionDate,
      comment: _comment,
    );
  }
}
