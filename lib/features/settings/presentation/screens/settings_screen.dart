import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/app/theme/app_colors_scheme.dart';
import 'package:yandex_school_homework/app/theme/texts_extension.dart';
import 'package:yandex_school_homework/app/theme/theme_notifier.dart';
import 'package:yandex_school_homework/features/common/ui/custom_app_bar.dart';
import 'package:yandex_school_homework/features/settings/domain/state/haptic/haptic_hotifier.dart';
import 'package:yandex_school_homework/features/settings/domain/state/localization_notifier/locale_notifier.dart';
import 'package:yandex_school_homework/features/settings/presentation/components/settings_tile.dart';
import 'package:yandex_school_homework/router/app_router.dart';

/// Экран настроек приложения
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.mainBackground,
      appBar: CustomAppBar(title: context.strings.settings),
      body: Column(
        children: [
          SettingsTile(
            leading: const Icon(Icons.lock),
            title: context.strings.pinSettingsButton,
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => context.pushNamed(AppRouter.pinSettings),
          ),
          const _ThemeSettingTile(),
          const _HapticSettingTile(),
          const _ColorSettingTile(),
          const _LanguageSettingTile(),
        ],
      ),
    );
  }
}

/// Виджет настройки темы (светлая/темная)
class _ThemeSettingTile extends StatelessWidget {
  const _ThemeSettingTile();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, _) {
        final isDarkForced = themeNotifier.themeMode == ThemeMode.dark;
        return SettingsTile(
          leading: Icon(isDarkForced ? Icons.dark_mode : Icons.light_mode),
          title: context.strings.darkThemeSetting,
          subtitle: isDarkForced
              ? context.strings.darkThemeEnabled
              : context.strings.darkThemeSystem,
          trailing: CupertinoSwitch(
            value: isDarkForced,
            onChanged: (value) => themeNotifier.changeTheme(value),
            activeTrackColor: context.colors.primary,
            inactiveTrackColor: context.colors.secondary,
          ),
        );
      },
    );
  }
}

/// Виджет настройки тактильной обратной связи
class _HapticSettingTile extends StatelessWidget {
  const _HapticSettingTile();

  @override
  Widget build(BuildContext context) {
    return Consumer<HapticFeedbackStatusNotifier>(
      builder: (context, hapticNotifier, _) {
        return SettingsTile(
          leading: const Icon(Icons.vibration),
          title: context.strings.hapticFeedbackSetting,
          subtitle: hapticNotifier.value
              ? context.strings.hapticFeedbackEnabled
              : context.strings.hapticFeedbackDisabled,
          trailing: CupertinoSwitch(
            value: hapticNotifier.value,
            onChanged: (value) async {
              await hapticNotifier.setHapticFeedbackEnabled(value);
              if (value) {
                await HapticFeedback.mediumImpact();
              }
            },
            activeTrackColor: context.colors.primary,
            inactiveTrackColor: context.colors.secondary,
          ),
        );
      },
    );
  }
}

/// Виджет настройки основного цвета приложения
class _ColorSettingTile extends StatefulWidget {
  const _ColorSettingTile();

  @override
  State<_ColorSettingTile> createState() => _ColorSettingTileState();
}

class _ColorSettingTileState extends State<_ColorSettingTile> {
  late Color _currentPickerColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentPickerColor = context.theme.primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, _) {
        return SettingsTile(
          leading: const Icon(Icons.palette),
          title: context.strings.primaryColorSetting,
          trailing: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: themeNotifier.primaryColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black12),
            ),
          ),
          onTap: () => _showColorPicker(context, themeNotifier),
        );
      },
    );
  }

  void _showColorPicker(BuildContext context, ThemeNotifier themeNotifier) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            context.strings.colorPickerTitle,
            style: context.texts.bodyLarge_.copyWith(
              color: context.colors.onSurfaceText,
            ),
          ),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _currentPickerColor,
              onColorChanged: (color) {
                setState(() {
                  _currentPickerColor = color;
                });
              },
              pickerAreaHeightPercent: 0.8,
              enableAlpha: false,
              displayThumbColor: true,
              labelTypes: const [],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                context.strings.cancel,
                style: context.texts.bodyLarge_.copyWith(
                  color: context.colors.primary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                themeNotifier.changePrimaryColor(_currentPickerColor);
                Navigator.pop(context);
              },
              child: Text(
                context.strings.save,
                style: context.texts.bodyLarge_.copyWith(
                  color: context.colors.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Виджет настройки языка приложения
class _LanguageSettingTile extends StatelessWidget {
  const _LanguageSettingTile();

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleNotifier>(
      builder: (context, localeNotifier, _) {
        return SettingsTile(
          leading: const Icon(Icons.language),
          title: context.strings.languageSettingTitle,
          trailing: DropdownButton<Locale>(
            value: localeNotifier.locale,
            underline: const SizedBox(),
            items: localeNotifier.supportedLocales.map((locale) {
              return DropdownMenuItem<Locale>(
                value: locale,
                child: Text(
                  _getLanguageName(locale, context),
                  style: context.texts.bodyLarge_.copyWith(
                    color: context.colors.onSurfaceText,
                  ),
                ),
              );
            }).toList(),
            onChanged: (Locale? newLocale) {
              if (newLocale != null) {
                localeNotifier.changeLocale(newLocale);
              }
            },
          ),
        );
      },
    );
  }

  /// Возвращает название языка по локали
  String _getLanguageName(Locale locale, BuildContext context) {
    switch (locale.languageCode) {
      case 'ru':
        return context.strings.russianLanguage;
      case 'en':
        return context.strings.englishLanguage;
      default:
        return locale.languageCode.toUpperCase();
    }
  }
}
