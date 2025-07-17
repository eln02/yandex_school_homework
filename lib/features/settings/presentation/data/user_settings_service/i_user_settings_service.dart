import 'package:flutter/material.dart';

/// Интерфейс для работы с настройками пользователя
abstract class IUserSettingsService {
  /// Инициализация сервиса (загрузка сохраненных данных)
  Future<void> init();

  /// Получить текущую тему (синхронно, после инициализации)
  ThemeMode get themeMode;

  /// Сохранить выбранную тему
  Future<void> saveThemeMode(ThemeMode mode);
}
