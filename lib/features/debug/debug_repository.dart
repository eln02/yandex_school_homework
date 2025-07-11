import 'package:yandex_school_homework/app/http/i_http_client.dart';

/// Тестовый репозиторий чтобы проверить ретраи при ошибке 500
final class DebugRepository {
  DebugRepository({required this.httpClient});

  final IHttpClient httpClient;

  Future<void> get500error() async {
    await httpClient.post('transactions', data: {});
  }
}
