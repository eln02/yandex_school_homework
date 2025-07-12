/// Класс, представляющий операцию резервного копирования для синхронизации данных.
///
/// Используется для хранения информации о локальных изменениях, которые нужно
/// синхронизировать с сервером. Поддерживает три типа операций: создание,
/// обновление и удаление сущностей.
class BackupOperation {
  /// Уникальный идентификатор операции
  final String id;

  /// Тип операции: 'CREATE'|'UPDATE'|'DELETE'
  final String operationType;

  /// Тип сущности: 'account'|'transaction'|'category'
  final String entityType;

  /// ID сущности, к которой относится операция
  final String entityId;

  /// Данные операции в формате ключ-значение
  /// Для CREATE - все поля сущности
  /// Для UPDATE - только изменяемые поля
  /// Для DELETE - может быть пустым
  final Map<String, dynamic> payload;

  /// Время создания операции
  final DateTime createdAt;

  /// Флаг, указывающий была ли операция синхронизирована с сервером
  final bool isSynced;

  /// Создает экземпляр [BackupOperation]
  BackupOperation({
    required this.id,
    required this.operationType,
    required this.entityType,
    required this.entityId,
    required this.payload,
    required this.createdAt,
    required this.isSynced,
  });

  /// Преобразует объект в Map для сохранения в базу данных
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': operationType,
    'entity': entityType,
    'entity_id': entityId,
    'data': payload,
    'created_at': createdAt.millisecondsSinceEpoch,
    'is_synced': isSynced ? 1 : 0,
  };
}
