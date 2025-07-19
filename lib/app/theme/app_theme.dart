import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_school_homework/app/theme/theme_constants.dart';
import 'package:yandex_school_homework/app/theme/theme_notifier.dart';

extension AppTheme on BuildContext {
  ThemeNotifier get notifier => watch<ThemeNotifier>();

  Color get _color => notifier.primaryColor;

  Color get _color2 => notifier.secondaryColor;

  ThemeData get light => ThemeData.light().copyWith(
    colorScheme: const ColorScheme.light().copyWith(
      primary: _color,
      secondary: _color2,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.onSurfaceTextLight),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: _color),
    scaffoldBackgroundColor: AppColors.mainBackgroundLight,
  );

  ThemeData get dark => ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark().copyWith(
      primary: _color,
      secondary: _color2,
      surface: AppColors.mainBackgroundDark,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.onSurfaceTextDark),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: _color),
    scaffoldBackgroundColor: AppColors.mainBackgroundDark,
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.surfaceContainerDark,
    ),
  );
}
