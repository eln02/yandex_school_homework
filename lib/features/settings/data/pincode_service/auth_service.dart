import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:yandex_school_homework/features/settings/data/pincode_service/i_auth_service.dart';

class SecureAuthService implements IAuthService {
  @visibleForTesting
  static const pinKey = 'user_pin_hash';
  @visibleForTesting
  static const biometricFlagKey = 'biometric_enabled';

  final FlutterSecureStorage _secureStorage;
  bool _isPinSet = false;
  bool _isBiometricEnabled = false;

  SecureAuthService({required FlutterSecureStorage secureStorage})
    : _secureStorage = secureStorage;

  @override
  bool get isPinSet => _isPinSet;

  @override
  bool get isBiometricEnabledCached => _isBiometricEnabled;

  @visibleForTesting
  String hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Future<void> init() async {
    _isPinSet = await _secureStorage.containsKey(key: pinKey);
    final biometricValue = await _secureStorage.read(key: biometricFlagKey);
    _isBiometricEnabled = biometricValue == 'true';
  }

  @override
  Future<void> savePin(String pin) async {
    final hashedPin = hashPin(pin);
    final exists = await _secureStorage.containsKey(key: pinKey);
    if (exists) {
      throw Exception("PIN already exists. Use updatePin to change it.");
    }
    await _secureStorage.write(key: pinKey, value: hashedPin);
    _isPinSet = true;
  }

  @override
  Future<bool> validatePin(String pin) async {
    final storedHash = await _secureStorage.read(key: pinKey);
    if (storedHash == null) return false;
    return storedHash == hashPin(pin);
  }

  @override
  Future<void> updatePin(String oldPin, String newPin) async {
    final isValid = await validatePin(oldPin);
    if (!isValid) {
      throw Exception("Old PIN is incorrect.");
    }
    final newHashedPin = hashPin(newPin);
    await _secureStorage.write(key: pinKey, value: newHashedPin);
  }

  @override
  Future<void> deletePin() async {
    await _secureStorage.delete(key: pinKey);
    _isPinSet = false;
  }

  @override
  Future<void> setBiometricEnabled(bool enabled) async {
    await _secureStorage.write(
      key: biometricFlagKey,
      value: enabled.toString(),
    );
    _isBiometricEnabled = enabled;
  }

  @override
  Future<bool> isBiometricEnabled() async {
    return _isBiometricEnabled;
  }
}
