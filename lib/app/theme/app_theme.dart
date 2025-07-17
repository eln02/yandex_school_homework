import 'package:flutter/material.dart';
import 'package:yandex_school_homework/app/theme/theme_constants.dart';

abstract class AppTheme {
  static ThemeData get light => ThemeData.light().copyWith(
    colorScheme: const ColorScheme.light().copyWith(
      primary: AppColors.financeGreen,
      secondary: AppColors.lightFinanceGreenLight,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.onSurfaceTextLight),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.financeGreen,
    ),
    scaffoldBackgroundColor: AppColors.mainBackgroundLight,
    cardColor: AppColors.surfaceContainerLight,
    dividerColor: AppColors.transactionsDividerLight,
  );

  static ThemeData get dark => ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark().copyWith(
      primary: AppColors.financeGreen,
      secondary: AppColors.lightFinanceGreenDark,
      surface: AppColors.mainBackgroundDark,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.onSurfaceTextDark),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.financeGreen,
    ),
    scaffoldBackgroundColor: AppColors.mainBackgroundDark,
    cardColor: AppColors.surfaceContainerDark,
    dividerColor: AppColors.transactionsDividerDark,
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.surfaceContainerDark,
    ),
  );
}
