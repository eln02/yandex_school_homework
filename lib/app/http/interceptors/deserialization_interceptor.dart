import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:worker_manager/worker_manager.dart';

/// Интерцептор для десериализации JSON-ответов в изолятах.
class DeserializationInterceptor extends Interceptor {
  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    // Получаем конфиг десериализации из параметров запроса
    final config = response.requestOptions.extra['_deserialize'];

    // Если конфига нет или данные пустые - пропускаем обработку
    if (config == null || response.data == null) {
      return handler.next(response);
    }

    // Приводим конфиг к нужному типу (функция fromJson + флаг isList)
    final (fromJson, isList) = config as (Function, bool);

    // Подготавливаем JSON-строку (если данные не в строковом формате)
    final jsonString = response.data is String
        ? response.data as String
        : jsonEncode(response.data);

    // Выполняем десериализацию в фоновом изоляте
    final result = await workerManager.execute(() {
      // Парсим JSON-строку
      final decoded = jsonDecode(jsonString);

      // Обрабатываем в зависимости от типа (список или одиночный объект)
      if (isList) {
        return (decoded as List).map((e) => fromJson(e)).toList();
      }
      return fromJson(decoded);
    });

    // Заменяем данные в ответе на десериализованные
    response.data = result;
    handler.next(response);
  }
}
