import 'package:flutter/material.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:yandex_school_homework/features/debug/i_debug_service.dart';

class DebugService implements IDebugService {
  static const name = 'DebugService';

  DebugService() {
    _talker = TalkerFlutter.init();
    _talkerDioLogger = TalkerDioLogger(
      talker: _talker,
      settings: const TalkerDioLoggerSettings(
        //printRequestHeaders: true,
        printRequestData: true,
        //printResponseHeaders: true,
        printResponseData: true,
      ),
    );
  }

  late final Talker _talker;
  late final TalkerDioLogger _talkerDioLogger;

  @override
  TalkerDioLogger get dioLogger => _talkerDioLogger;

  @override
  void logDebug(
    Object message, {
    Object? logLevel,
    Map<String, dynamic>? args,
  }) {
    _talker.debug(message);
  }

  @override
  void logError(
    Object message, {
    Object? error,
    Object? logLevel,
    Map<String, dynamic>? args,
    StackTrace? stackTrace,
  }) {
    _talker.error(message, error, stackTrace);
  }

  @override
  void log(Object message, {Object? logLevel, Map<String, dynamic>? args}) {
    _talker.log(message);
  }

  @override
  void logWarning(
    Object message, {
    Object? logLevel,
    Map<String, dynamic>? args,
  }) {
    _talker.warning(message);
  }

  @override
  Future<T?> openDebugScreen<T>(
    BuildContext context, {
    bool useRootNavigator = false,
  }) {
    return Navigator.of(
      context,
      rootNavigator: useRootNavigator,
    ).push<T>(MaterialPageRoute(builder: (_) => TalkerScreen(talker: _talker)));
  }
}
