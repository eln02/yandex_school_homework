import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_request_entity.dart';

/// Результат работы модального окна редактирования транзакции
abstract class TransactionEditResult {
  /// Для создания/редактирования
  factory TransactionEditResult.success(TransactionRequestEntity request) =
      TransactionEditSuccess;

  /// Для удаления
  factory TransactionEditResult.deleted() = TransactionEditDeleted;

  /// Для отмены
  factory TransactionEditResult.canceled() = TransactionEditCanceled;
}

class TransactionEditSuccess implements TransactionEditResult {
  final TransactionRequestEntity request;

  TransactionEditSuccess(this.request);
}

class TransactionEditDeleted implements TransactionEditResult {}

class TransactionEditCanceled implements TransactionEditResult {}
