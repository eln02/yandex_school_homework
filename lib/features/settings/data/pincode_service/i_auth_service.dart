abstract class IAuthService {
  Future<void> init();

  Future<void> savePin(String pin);

  Future<bool> validatePin(String pin);

  Future<void> updatePin(String oldPin, String newPin);

  Future<void> deletePin();

  bool get isPinSet;

  bool get isBiometricEnabledCached;

  Future<void> setBiometricEnabled(bool enabled);

  Future<bool> isBiometricEnabled();
}
