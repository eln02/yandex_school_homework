import 'package:flutter/material.dart';
import 'package:yandex_school_homework/features/settings/presentation/data/user_settings_service/i_user_settings_service.dart';

final class LocaleNotifier extends ChangeNotifier {
  final IUserSettingsService _settingsService;
  Locale _locale;

  static const List<Locale> _supportedLocales = [Locale('ru'), Locale('en')];

  LocaleNotifier(this._settingsService) : _locale = const Locale('ru') {
    _initLocale();
  }

  List<Locale> get supportedLocales => _supportedLocales;

  Future<void> _initLocale() async {
    try {
      final savedLocale = _settingsService.locale;
      _locale = _isLocaleSupported(savedLocale)
          ? savedLocale
          : _supportedLocales.first;
      notifyListeners();
    } catch (e) {
      _locale = _supportedLocales.first;
    }
  }

  bool _isLocaleSupported(Locale locale) {
    return _supportedLocales.any(
      (supported) => supported.languageCode == locale.languageCode,
    );
  }

  Locale get locale => _locale;

  Future<void> changeLocale(Locale newLocale) async {
    if (!_isLocaleSupported(newLocale)) {
      return;
    }

    if (_locale.languageCode != newLocale.languageCode) {
      await _settingsService.saveLocale(newLocale);
      _locale = newLocale;
      notifyListeners();
    }
  }

  Future<void> toggleLocale() async {
    final currentIndex = _supportedLocales.indexWhere(
      (l) => l.languageCode == _locale.languageCode,
    );

    if (currentIndex == -1) return;

    final nextIndex = (currentIndex + 1) % _supportedLocales.length;
    await changeLocale(_supportedLocales[nextIndex]);
  }
}
