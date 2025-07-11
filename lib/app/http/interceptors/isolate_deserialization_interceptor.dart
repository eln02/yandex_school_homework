import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:worker_manager/worker_manager.dart';

class StrictTypingDeserializationInterceptor extends Interceptor {
  @override
  Future<void> onResponse(
      Response response,
      ResponseInterceptorHandler handler,
      ) async {
    try {
      final config = response.requestOptions.extra['_deserialize'];
      if (config == null || response.data == null) {
        return handler.next(response);
      }

      final (fromJson, isList) = config as (Function, bool);

      final jsonString = response.data is String
          ? response.data as String
          : jsonEncode(response.data);

      final result = await workerManager.execute(
            () {
          final decoded = jsonDecode(jsonString);
          if (isList) {
            return (decoded as List).map((e) => fromJson(e)).toList();
          }
          return fromJson(decoded);
        },
      );

      response.data = result;
      handler.next(response);
    } catch (e, _) {
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          error: 'Deserialization failed',
          response: response,
        ),
      );
    }
  }
}