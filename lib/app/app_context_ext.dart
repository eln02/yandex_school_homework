import 'package:flutter/material.dart';
import 'package:yandex_school_homework/app/theme/theme_notifier.dart';
import 'package:yandex_school_homework/di/di_container.dart';
import 'package:provider/provider.dart';

extension AppContextExt on BuildContext {
  DiContainer get di => read<DiContainer>();

  ColorScheme get colors => Theme.of(this).colorScheme;

  ThemeNotifier get theme => read<ThemeNotifier>();

  TextTheme get texts => Theme.of(this).textTheme;
}
