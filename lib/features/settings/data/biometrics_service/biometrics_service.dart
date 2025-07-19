import 'package:local_auth/local_auth.dart';
import 'package:yandex_school_homework/features/settings/data/biometrics_service/i_biometric_auth_service.dart';

class BiometricAuthService implements IBiometricAuthService {
  final LocalAuthentication _auth;
  bool _isBiometricAvailable = false;

  BiometricAuthService({required LocalAuthentication auth}) : _auth = auth;

  @override
  bool get isBiometricAvailable => _isBiometricAvailable;

  @override
  Future<void> init() async {
    final canCheck = await _auth.canCheckBiometrics;
    final isSupported = await _auth.isDeviceSupported();
    _isBiometricAvailable = canCheck && isSupported;
  }

  @override
  Future<bool> authenticate({
    String reason = 'Пожалуйста, подтвердите биометрию',
  }) async {
    if (!_isBiometricAvailable) {
      throw Exception('Биометрия недоступна на устройстве');
    }

    try {
      final didAuthenticate = await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      return didAuthenticate;
    } catch (e) {
      return false;
    }
  }
}