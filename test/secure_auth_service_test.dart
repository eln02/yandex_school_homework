import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:crypto/crypto.dart';
import 'package:yandex_school_homework/features/settings/data/pincode_service/auth_service.dart';
import 'package:yandex_school_homework/features/settings/data/pincode_service/i_auth_service.dart';
import 'dart:convert';
import 'secure_auth_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FlutterSecureStorage>()])
void main() {
  late IAuthService authService;
  late MockFlutterSecureStorage mockStorage;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    authService = SecureAuthService(secureStorage: mockStorage);
  });

  String hashPin(String pin) => sha256.convert(utf8.encode(pin)).toString();

  group('init()', () {
    test('should initialize with PIN set and biometric enabled', () async {
      when(
        mockStorage.containsKey(key: 'user_pin_hash'),
      ).thenAnswer((_) async => true);
      when(
        mockStorage.read(key: 'biometric_enabled'),
      ).thenAnswer((_) async => 'true');

      await authService.init();

      expect(authService.isPinSet, true);
      expect(authService.isBiometricEnabledCached, true);
    });
  });

  group('savePin()', () {
    test('should save hashed PIN when no PIN exists', () async {
      when(
        mockStorage.containsKey(key: 'user_pin_hash'),
      ).thenAnswer((_) async => false);
      when(
        mockStorage.write(key: 'user_pin_hash', value: anyNamed('value')),
      ).thenAnswer((_) async {});

      await authService.savePin('1234');

      verify(
        mockStorage.write(key: 'user_pin_hash', value: hashPin('1234')),
      ).called(1);
    });
  });

  group('validatePin()', () {
    test('should return true for correct PIN', () async {
      when(
        mockStorage.read(key: 'user_pin_hash'),
      ).thenAnswer((_) async => hashPin('1234'));

      expect(await authService.validatePin('1234'), true);
    });
  });

  group('updatePin()', () {
    test('should update PIN when old PIN is correct', () async {
      when(
        mockStorage.read(key: 'user_pin_hash'),
      ).thenAnswer((_) async => hashPin('1234'));
      when(
        mockStorage.write(key: 'user_pin_hash', value: anyNamed('value')),
      ).thenAnswer((_) async {});

      await authService.updatePin('1234', '5678');

      verify(
        mockStorage.write(key: 'user_pin_hash', value: hashPin('5678')),
      ).called(1);
    });
  });

  group('biometric methods', () {
    test('should enable biometric authentication', () async {
      when(
        mockStorage.write(key: 'biometric_enabled', value: 'true'),
      ).thenAnswer((_) async {});

      await authService.setBiometricEnabled(true);

      verify(
        mockStorage.write(key: 'biometric_enabled', value: 'true'),
      ).called(1);
    });
  });
}
