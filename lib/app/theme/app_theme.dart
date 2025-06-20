import 'package:flutter/material.dart';
import 'package:yandex_school_homework/app/theme/theme_constants.dart';

abstract class AppTheme {
  static ThemeData get light => ThemeData.light().copyWith(
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.onSurfaceText),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.financeGreen,
    ),
    scaffoldBackgroundColor: AppColors.mainBackground,
  );

  static ThemeData get dark => ThemeData.dark();
}
