import 'package:flutter/material.dart';

/// Интерфейс для работы с настройками пользователя
abstract class IUserSettingsService {
  /// Инициализация сервиса (загрузка сохраненных данных)
  Future<void> init();

  /// Получить текущую тему (синхронно, после инициализации)
  ThemeMode get themeMode;

  /// Сохранить выбранную тему
  Future<void> saveThemeMode(ThemeMode mode);

  Color get primaryColor;

  Future<void> savePrimaryColor(Color color);

  Locale get locale;

  Future<void> saveLocale(Locale locale);

  /// Получить текущее состояние звукового отклика
  bool get hapticFeedbackEnabled;

  /// Сохранить состояние звукового отклика
  Future<void> saveHapticFeedbackEnabled(bool enabled);
}
