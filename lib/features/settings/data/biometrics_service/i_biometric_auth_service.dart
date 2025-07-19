abstract class IBiometricAuthService {
  Future<void> init();

  bool get isBiometricAvailable;

  Future<bool> authenticate({String reason});
}
