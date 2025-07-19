import 'package:flutter/material.dart';
import 'package:yandex_school_homework/app/theme/theme_notifier.dart';
import 'package:yandex_school_homework/di/di_container.dart';
import 'package:provider/provider.dart';
import 'package:yandex_school_homework/l10n/app_localizations.dart';
import 'package:yandex_school_homework/features/settings/domain/state/localization_notifier/locale_notifier.dart';

extension AppContextExt on BuildContext {
  DiContainer get di => read<DiContainer>();

  ColorScheme get colors => Theme.of(this).colorScheme;

  ThemeNotifier get theme => read<ThemeNotifier>();

  LocaleNotifier get locale => watch<LocaleNotifier>();

  TextTheme get texts => Theme.of(this).textTheme;

  AppLocalizations get strings => AppLocalizations.of(this)!;

  ThemeNotifier get _tint => watch<ThemeNotifier>();

  Color get primaryColor => _tint.primaryColor;

  Color get secondaryColor => _tint.secondaryColor;

  Color get textColor => _tint.textColor;
}
