import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yandex_school_homework/app/theme/theme_constants.dart';
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
  late Color _primaryColor;

  ThemeNotifier(this._settingsService) {
    _initTheme();
  }

  Future<void> _initTheme() async {
    _themeMode = _settingsService.themeMode;
    _primaryColor = _settingsService.primaryColor;
    notifyListeners();
  }

  ThemeMode get themeMode => _themeMode;

  Color get primaryColor => _primaryColor;

  Color get secondaryColor => _primaryColor.withAlpha(76);

  Color get textColor => getTextColorForBackground(_primaryColor);

  Color getTextColorForBackground(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();

    return luminance < 0.1
        ? AppColors.onSurfaceTextDark
        : AppColors.onSurfaceTextLight;
  }

  Future<void> changeTheme(bool useDarkTheme) async {
    _themeMode = useDarkTheme ? ThemeMode.dark : ThemeMode.system;
    await _settingsService.saveThemeMode(_themeMode);
    notifyListeners();
  }

  Future<void> changePrimaryColor(Color color) async {
    _primaryColor = color;
    await _settingsService.savePrimaryColor(color);
    notifyListeners();
  }
}
