import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_school_homework/app/theme/theme_constants.dart';
import 'package:yandex_school_homework/features/settings/data/user_settings_service/i_user_settings_service.dart';

class UserSettingsService implements IUserSettingsService {
  static const _themeModeKey = 'theme_mode';
  static const _primaryColorKey = 'primary_color';
  static const _localeLanguageKey = 'locale_language';
  static const _hapticFeedbackKey = 'haptic_feedback';

  final SharedPreferences _prefs;
  ThemeMode _cachedThemeMode;
  Color _cachedPrimaryColor;
  Locale _cachedLocale;
  bool _cachedHapticFeedback;

  UserSettingsService({
    required SharedPreferences prefs,
    ThemeMode? initialThemeMode,
    Color? initialPrimaryColor,
    Locale? initialLocale,
    bool? initialHapticFeedback,
  }) : _prefs = prefs,
       _cachedThemeMode = initialThemeMode ?? ThemeMode.system,
       _cachedPrimaryColor = initialPrimaryColor ?? AppColors.financeGreen,
       _cachedLocale = initialLocale ?? const Locale('ru'),
       _cachedHapticFeedback = initialHapticFeedback ?? true;

  @override
  Future<void> init() async {
    _cachedThemeMode = await _loadThemeMode();
    _cachedPrimaryColor = await _loadPrimaryColor();
    _cachedLocale = await _loadLocale();
    _cachedHapticFeedback = await _loadHapticFeedback();
  }

  Future<bool> _loadHapticFeedback() async {
    return _prefs.getBool(_hapticFeedbackKey) ?? false;
  }

  @override
  bool get hapticFeedbackEnabled => _cachedHapticFeedback;

  @override
  Future<void> saveHapticFeedbackEnabled(bool enabled) async {
    _cachedHapticFeedback = enabled;
    await _prefs.setBool(_hapticFeedbackKey, enabled);
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

  Future<Color> _loadPrimaryColor() async {
    final colorValue = _prefs.getInt(_primaryColorKey);
    return colorValue != null ? Color(colorValue) : AppColors.financeGreen;
  }

  @override
  ThemeMode get themeMode => _cachedThemeMode;

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    _cachedThemeMode = mode;
    await _prefs.setString(_themeModeKey, mode.toString());
  }

  @override
  Color get primaryColor => _cachedPrimaryColor;

  @override
  Future<void> savePrimaryColor(Color color) async {
    _cachedPrimaryColor = color;
    await _prefs.setInt(_primaryColorKey, color.toARGB32());
  }

  Future<Locale> _loadLocale() async {
    final languageCode = _prefs.getString(_localeLanguageKey);
    return languageCode != null ? Locale(languageCode) : const Locale('ru');
  }

  @override
  Locale get locale => _cachedLocale;

  @override
  Future<void> saveLocale(Locale locale) async {
    _cachedLocale = locale;
    await _prefs.setString(_localeLanguageKey, locale.languageCode);
  }
}
