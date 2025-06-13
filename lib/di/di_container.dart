import 'package:yandex_school_homework/app/http/app_http_client.dart';
import 'package:yandex_school_homework/app/http/i_http_client.dart';
import 'package:yandex_school_homework/di/di_repositories.dart';
import 'package:yandex_school_homework/di/di_typedefs.dart';
import 'package:yandex_school_homework/features/debug/i_debug_service.dart';

final class DiContainer {
  DiContainer({required IDebugService dService}) : debugService = dService;

  late final IDebugService debugService;

  late final IHttpClient httpClient;

  late final DiRepositories repositories;

  Future<void> init({
    required OnProgress onProgress,
    required OnComplete onComplete,
    required OnError onError,
  }) async {
    httpClient = AppHttpClient(debugService: debugService);
    repositories = DiRepositories()
      ..init(onProgress: onProgress, onError: onError, diContainer: this);

    onComplete('Инициализация зависимостей завершена!');
  }
}
