import 'package:flutter/material.dart';
import 'package:yandex_school_homework/features/settings/presentation/data/user_settings_service/i_user_settings_service.dart';

class HapticFeedbackStatusNotifier extends ValueNotifier<bool> {
  final IUserSettingsService _settingsService;

  HapticFeedbackStatusNotifier(this._settingsService)
      : super(_settingsService.hapticFeedbackEnabled);

  Future<void> setHapticFeedbackEnabled(bool enabled) async {
    value = enabled;
    await _settingsService.saveHapticFeedbackEnabled(enabled);
  }
}