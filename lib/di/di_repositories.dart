import 'package:yandex_school_homework/app/env_config/env_config.dart';
import 'package:yandex_school_homework/di/di_base_repo.dart';
import 'package:yandex_school_homework/di/di_container.dart';
import 'package:yandex_school_homework/di/di_typedefs.dart';

final class DiRepositories {

  void init({
    required OnProgress onProgress,
    required OnError onError,
    required DiContainer diContainer,
  }) {}

  T _lazyInitRepo<T extends DiBaseRepo>({
    required T Function() mainFactory,
    required T Function() mockFactory,
  }) {
    return EnvConfig.useMocks.toLowerCase() == 'true'
        ? mockFactory()
        : mainFactory();
  }
}
