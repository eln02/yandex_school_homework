import 'package:flutter/material.dart';
import 'package:yandex_school_homework/features/settings/data/pincode_service/i_auth_service.dart';


class BiometricStatusNotifier extends ValueNotifier<bool> {
  final IAuthService _authService;

  BiometricStatusNotifier(this._authService)
    : super(_authService.isBiometricEnabledCached);

  Future<void> setBiometricEnabled(bool enabled) async {
    await _authService.setBiometricEnabled(enabled);
    value = enabled;
  }
}
