import 'package:yandex_school_homework/app/database/database_service.dart';
import 'package:yandex_school_homework/app/database/i_database_service.dart';
import 'package:yandex_school_homework/app/http/app_http_client.dart';
import 'package:yandex_school_homework/app/http/i_http_client.dart';
import 'package:yandex_school_homework/di/di_repositories.dart';
import 'package:yandex_school_homework/di/di_typedefs.dart';
import 'package:yandex_school_homework/features/debug/i_debug_service.dart';

final class DiContainer {
  DiContainer({
    required IDebugService dService,
    String databaseName = 'finance_app.db',
    int databaseVersion = 1,
  }) : debugService = dService,
       _databaseName = databaseName,
       _databaseVersion = databaseVersion;

  final String _databaseName;
  final int _databaseVersion;

  late final IDebugService debugService;

  late final IHttpClient httpClient;

  late final IDatabaseService databaseService;

  late final DiRepositories repositories;

  Future<void> init({
    required OnProgress onProgress,
    required OnComplete onComplete,
    required OnError onError,
  }) async {
    onProgress('Инициализация HTTP клиента...');
    httpClient = AppHttpClient(debugService: debugService);

    onProgress('Инициализация базы данных...');
    databaseService = DatabaseService(
      databaseName: _databaseName,
      databaseVersion: _databaseVersion,
      debugService: debugService,
    );

    onProgress('Инициализация репозиториев...');
    repositories = DiRepositories()
      ..init(onProgress: onProgress, onError: onError, diContainer: this);

    onComplete('Инициализация зависимостей завершена!');

    onComplete('Инициализация зависимостей завершена!');
  }
}
