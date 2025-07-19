import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/app/theme/theme_notifier.dart';
import 'package:yandex_school_homework/features/settings/presentation/domain/state/haptic/haptic_hotifier.dart';
import 'package:yandex_school_homework/l10n/locale_notifier.dart';
import 'package:yandex_school_homework/router/app_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Color _currentPickerColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentPickerColor = context.theme.primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.strings.settingsTitle),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => context.pushNamed(AppRouter.pinSettings),
              child: Text(context.strings.pinSettingsButton),
            ),
            _buildThemeSwitch(context),
            const SizedBox(height: 16),
            _buildHapticToggle(context),
            const SizedBox(height: 16),
            _buildColorPicker(context),
            const SizedBox(height: 16),
            _buildLanguageDropdown(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown(BuildContext context) {
    return Consumer<LocaleNotifier>(
      builder: (context, localeNotifier, child) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(Icons.language, color: context.primaryColor),
            title: Text(context.strings.languageSettingTitle),
            trailing: DropdownButton<Locale>(
              value: localeNotifier.locale,
              underline: const SizedBox(),
              items: localeNotifier.supportedLocales.map((locale) {
                return DropdownMenuItem<Locale>(
                  value: locale,
                  child: Text(
                    _getLanguageName(locale, context),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }).toList(),
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  localeNotifier.changeLocale(newLocale);
                }
              },
            ),
          ),
        );
      },
    );
  }

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

  Widget _buildColorPicker(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(Icons.palette, color: context.primaryColor),
            title: Text(context.strings.primaryColorSetting),
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
          ),
        );
      },
    );
  }

  void _showColorPicker(BuildContext context, ThemeNotifier themeNotifier) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.strings.colorPickerTitle),
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
              child: Text(context.strings.cancel),
            ),
            TextButton(
              onPressed: () {
                themeNotifier.changePrimaryColor(_currentPickerColor);
                Navigator.pop(context);
              },
              child: Text(context.strings.save),
            ),
          ],
        );
      },
    );
  }

  // Новый виджет для переключателя хаптика
  Widget _buildHapticToggle(BuildContext context) {
    return Consumer<HapticFeedbackStatusNotifier>(
      builder: (context, hapticNotifier, child) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(Icons.vibration, color: context.primaryColor),
            title: Text(
              context.strings.hapticFeedbackSetting,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              hapticNotifier.value
                  ? context.strings.hapticFeedbackEnabled
                  : context.strings.hapticFeedbackDisabled,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: Switch.adaptive(
              value: hapticNotifier.value,
              onChanged: (value) async {
                await hapticNotifier.setHapticFeedbackEnabled(value);
                if (value) {
                  await HapticFeedback.mediumImpact();
                }
              },
              activeColor: context.primaryColor,
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeSwitch(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        final isDarkForced = themeNotifier.themeMode == ThemeMode.dark;
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(
              isDarkForced ? Icons.dark_mode : Icons.light_mode,
              color: context.primaryColor,
            ),
            title: Text(
              context.strings.darkThemeSetting,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              isDarkForced
                  ? context.strings.darkThemeEnabled
                  : context.strings.darkThemeSystem,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: Switch.adaptive(
              value: isDarkForced,
              onChanged: (value) => themeNotifier.changeTheme(value),
              activeColor: context.primaryColor,
            ),
          ),
        );
      },
    );
  }
}
