import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_school_homework/features/settings/presentation/data/user_settings_service/i_user_settings_service.dart';

class UserSettingsService implements IUserSettingsService {
  static const _themeModeKey = 'theme_mode';
  late final SharedPreferences _prefs;
  ThemeMode _cachedThemeMode = ThemeMode.system;

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _cachedThemeMode = await _loadThemeMode();
  }

  Future<ThemeMode> _loadThemeMode() async {
    final modeString = _prefs.getString(_themeModeKey);
    return modeString != null
        ? ThemeMode.values.firstWhere(
            (e) => e.toString() == modeString,
            orElse: () => ThemeMode.system,
          )
        : ThemeMode.system;
  }

  @override
  ThemeMode get themeMode => _cachedThemeMode;

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    _cachedThemeMode = mode;
    await _prefs.setString(_themeModeKey, mode.toString());
  }
}
