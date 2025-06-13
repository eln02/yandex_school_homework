import 'package:envied/envied.dart';

part 'env_config.g.dart';

@Envied(path: '.env')
abstract class EnvConfig {
  @EnviedField(varName: 'USE_MOCKS')
  static const String useMocks = _EnvConfig.useMocks;

  @EnviedField(varName: 'BASE_URL')
  static const String baseUrl = _EnvConfig.baseUrl;

  @EnviedField(varName: 'TOKEN', obfuscate: true)
  static final String token = _EnvConfig.token;
}
