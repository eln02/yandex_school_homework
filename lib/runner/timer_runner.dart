import 'package:yandex_school_homework/features/debug/i_debug_service.dart';

class TimerRunner {
  TimerRunner(this._debugService) {
    _stopwatch.start();
  }

  final IDebugService _debugService;

  final _stopwatch = Stopwatch();

  void stop() {
    _stopwatch.stop();
    _debugService.log(
      'Время инициализации приложения: ${_stopwatch.elapsedMilliseconds} мс',
    );
  }

  void logOnProgress(String name) {
    _debugService.log(
      '$name успешная инициализация, прогресс: ${_stopwatch.elapsedMilliseconds} мс',
    );
  }

  void logOnComplete(String message) {
    _debugService.log(
      '$message, прогресс: ${_stopwatch.elapsedMilliseconds} мс',
    );
  }

  void logOnError(String message, Object error, [StackTrace? stackTrace]) {
    _debugService.logError(() => message, error: error, stackTrace: stackTrace);
  }
}
