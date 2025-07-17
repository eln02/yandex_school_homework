import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yandex_school_homework/features/settings/presentation/data/user_settings_service/i_user_settings_service.dart';

typedef ThemeBuilder = Widget Function();

class ThemeConsumer extends StatelessWidget {
  const ThemeConsumer({super.key, required this.builder});

  final ThemeBuilder builder;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (_, __, ___) {
        return builder();
      },
    );
  }
}

final class ThemeNotifier extends ChangeNotifier {
  final IUserSettingsService _settingsService;
  late ThemeMode _themeMode;

  ThemeNotifier(this._settingsService) {
    _initTheme();
  }

  Future<void> _initTheme() async {
    _themeMode = _settingsService.themeMode;
    notifyListeners();
  }

  ThemeMode get themeMode => _themeMode;

  Future<void> changeTheme(bool useDarkTheme) async {
    _themeMode = useDarkTheme ? ThemeMode.dark : ThemeMode.system;
    await _settingsService.saveThemeMode(_themeMode);
    notifyListeners();
  }
}
