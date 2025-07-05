import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_school_homework/app/app.dart';
import 'package:yandex_school_homework/di/di_container.dart';
import 'package:yandex_school_homework/features/debug/debug_service.dart';
import 'package:yandex_school_homework/features/debug/i_debug_service.dart';
import 'package:yandex_school_homework/features/error/error_screen.dart';
import 'package:yandex_school_homework/router/app_router.dart';
import 'package:yandex_school_homework/runner/timer_runner.dart';
import 'package:intl/date_symbol_data_local.dart';

const _initTimeout = Duration(seconds: 7);

class AppRunner {
  AppRunner();

  late IDebugService _debugService;

  late GoRouter router;

  late TimerRunner _timerRunner;

  Future<void> run() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();

      /// Инициализация локализации
      await initializeDateFormatting('ru_RU');

      _debugService = DebugService();

      _timerRunner = TimerRunner(_debugService);

      await _initApp();

      _initErrorHandlers(_debugService);

      router = AppRouter.createRouter(_debugService);

      runApp(
        App(
          router: router,
          initDependencies: () {
            return _initDependencies(
              debugService: _debugService,
              timerRunner: _timerRunner,
            ).timeout(
              _initTimeout,
              onTimeout: () {
                return Future.error(
                  TimeoutException(
                    'Превышено время ожидания инициализации зависимостей',
                  ),
                );
              },
            );
          },
        ),
      );
      await _onAppLoaded();
    } on Object catch (e, stackTrace) {
      await _onAppLoaded();

      runApp(ErrorScreen(error: e, stackTrace: stackTrace, onRetry: run));
    }
  }

  Future<void> _initApp() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    WidgetsBinding.instance.deferFirstFrame();
  }

  Future<void> _onAppLoaded() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.allowFirstFrame();
    });
  }

  Future<DiContainer> _initDependencies({
    required IDebugService debugService,
    required TimerRunner timerRunner,
  }) async {
    final diContainer = DiContainer(dService: debugService);
    final initFuture = diContainer.init(
      onProgress: (name) => timerRunner.logOnProgress(name),
      onComplete: (name) {
        timerRunner
          ..logOnComplete(name)
          ..stop();
      },
      onError: (message, error, [stackTrace]) =>
          debugService.logError(message, error: error, stackTrace: stackTrace),
    );

    /// Запускает инициализацию зависимостей параллельно с задержкой 2200 мс
    /// - Ждёт минимум 2200 мс - минимальное время показа гифки в сплеше
    /// - Если инициализация дольше - ждёт её завершения
    await Future.wait([
      initFuture,
      Future.delayed(const Duration(milliseconds: 2200)),
    ], eagerError: true);

    return diContainer;
  }
}

void _initErrorHandlers(IDebugService debugService) {
  FlutterError.onError = (details) {
    _showErrorScreen(details.exception, details.stack);
    debugService.logError(
      () => 'FlutterError.onError: ${details.exceptionAsString()}',
      error: details.exception,
      stackTrace: details.stack,
    );
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    _showErrorScreen(error, stack);
    debugService.logError(
      () => 'PlatformDispatcher.instance.onError',
      error: error,
      stackTrace: stack,
    );
    return true;
  };
}

void _showErrorScreen(Object error, StackTrace? stackTrace) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    AppRouter.rootNavigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => ErrorScreen(error: error, stackTrace: stackTrace),
      ),
    );
  });
}
