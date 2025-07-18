import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

abstract class IPinCodeService {
  Future<void> init();

  Future<void> savePin(String pin);

  Future<bool> validatePin(String pin);

  Future<void> updatePin(String oldPin, String newPin);

  Future<void> deletePin();

  bool get isPinSet;
}

class SecurePinCodeService implements IPinCodeService {
  static const _pinKey = 'user_pin_hash';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  bool _isPinSet = false;

  @override
  bool get isPinSet => _isPinSet;

  String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Future<void> init() async {
    _isPinSet = await _secureStorage.containsKey(key: _pinKey);
  }

  @override
  Future<void> savePin(String pin) async {
    final hashedPin = _hashPin(pin);
    final exists = await _secureStorage.containsKey(key: _pinKey);
    if (exists) {
      throw Exception("PIN already exists. Use updatePin to change it.");
    }
    await _secureStorage.write(key: _pinKey, value: hashedPin);
    _isPinSet = true;
  }

  @override
  Future<bool> validatePin(String pin) async {
    final storedHash = await _secureStorage.read(key: _pinKey);
    if (storedHash == null) return false;
    return storedHash == _hashPin(pin);
  }

  @override
  Future<void> updatePin(String oldPin, String newPin) async {
    final isValid = await validatePin(oldPin);
    if (!isValid) {
      throw Exception("Old PIN is incorrect.");
    }
    final newHashedPin = _hashPin(newPin);
    await _secureStorage.write(key: _pinKey, value: newHashedPin);
  }

  @override
  Future<void> deletePin() async {
    await _secureStorage.delete(key: _pinKey);
    _isPinSet = false;
  }
}
