import 'package:dio/dio.dart';
import 'package:yandex_school_homework/app/env_config/env_config.dart';
import 'package:yandex_school_homework/app/http/i_http_client.dart';
import 'package:yandex_school_homework/features/debug/i_debug_service.dart';

final class AppHttpClient implements IHttpClient {
  AppHttpClient({
    required IDebugService debugService,
  }) {
    _httpClient = Dio();

    _httpClient.options
      ..baseUrl = EnvConfig.baseUrl
      ..connectTimeout = const Duration(seconds: 5)
      ..sendTimeout = const Duration(seconds: 7)
      ..receiveTimeout = const Duration(seconds: 10)
      ..headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${EnvConfig.token}',
      };
    debugService.log('HTTP client created');
    _httpClient.interceptors.add(debugService.dioLogger);
  }

  late final Dio _httpClient;

  @override
  Future<Response> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _httpClient.get(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  @override
  Future<Response> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _httpClient.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  @override
  Future<Response> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _httpClient.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  @override
  Future<Response> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _httpClient.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  @override
  Future<Response> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _httpClient.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  @override
  Future<Response> head(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _httpClient.head(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
