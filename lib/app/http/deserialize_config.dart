/// Конфигурация для десериализации JSON-ответов
///
/// Содержит:
/// - [fromJson]: Функцию для преобразования Map -> DTO
/// - [isList]: Флаг, указывающий на то, что ожидается список объектов
typedef DeserializeConfig = (Function fromJson, bool isList);
