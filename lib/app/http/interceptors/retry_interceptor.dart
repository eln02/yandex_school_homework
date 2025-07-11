import 'dart:math';
import 'package:dio/dio.dart';
import 'package:yandex_school_homework/features/debug/i_debug_service.dart';

/// Интерцептор для повторных запросов с exponential backoff
class RetryInterceptor extends Interceptor {
  final Dio _dio;
  final IDebugService debugService;

  RetryInterceptor(this._dio, this.debugService);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    const retryableStatusCodes = {500, 502, 503, 504, 408, 429};
    const maxRetryAttempts = 3;

    final statusCode = err.response?.statusCode;
    final currentRetryCount =
        (err.requestOptions.extra['retry_count'] as int?) ?? 0;

    // Проверяем, нужно ли повторять запрос
    if (statusCode == null ||
        !retryableStatusCodes.contains(statusCode) ||
        currentRetryCount >= maxRetryAttempts) {
      return handler.next(err);
    }

    // Увеличиваем счетчик попыток
    final nextRetryCount = currentRetryCount + 1;
    err.requestOptions.extra['retry_count'] = nextRetryCount;

    // Рассчитываем задержку
    final delayDuration = _calculateDelay(nextRetryCount);
    debugService.log(
      'Retry attempt $nextRetryCount/$maxRetryAttempts '
      'after ${delayDuration.inMilliseconds}ms',
    );

    // Ждем перед повторной попыткой
    await Future.delayed(delayDuration);

    try {
      // Повторяем запрос через оригинальный Dio клиент
      final response = await _dio.request(
        err.requestOptions.path,
        data: err.requestOptions.data,
        queryParameters: err.requestOptions.queryParameters,
        options: Options(
          method: err.requestOptions.method,
          headers: err.requestOptions.headers,
          extra: err.requestOptions.extra,
        ),
      );
      handler.resolve(response);
    } catch (e) {
      handler.next(err);
    }
  }

  Duration _calculateDelay(int retryCount) {
    const baseDelay = Duration(seconds: 1);
    final exponentialDelay = baseDelay * pow(2, retryCount).toInt();
    final jitter = Duration(
      milliseconds: Random().nextInt(500),
    ); // до 0.5с случайности
    final totalDelay = exponentialDelay + jitter;

    return totalDelay > const Duration(seconds: 30)
        ? const Duration(seconds: 30)
        : totalDelay;
  }
}
