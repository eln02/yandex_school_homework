import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_school_homework/app/theme/theme_constants.dart';
import 'package:yandex_school_homework/app/theme/theme_notifier.dart';

extension AppTheme on BuildContext {
  Color get _color => watch<ThemeNotifier>().primaryColor;

  ThemeData get light => ThemeData.light().copyWith(
    colorScheme: const ColorScheme.light().copyWith(
      primary: AppColors.financeGreen,
      secondary: AppColors.financeGreenWithOpacity,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.onSurfaceTextLight),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: _color),
    scaffoldBackgroundColor: AppColors.mainBackgroundLight,
    cardColor: AppColors.surfaceContainerLight,
    dividerColor: AppColors.transactionsDividerLight,
  );

  ThemeData get dark => ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark().copyWith(
      primary: AppColors.financeGreen,
      secondary: AppColors.financeGreenWithOpacity,
      surface: AppColors.mainBackgroundDark,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.onSurfaceTextDark),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: _color),
    scaffoldBackgroundColor: AppColors.mainBackgroundDark,
    cardColor: AppColors.surfaceContainerDark,
    dividerColor: AppColors.transactionsDividerDark,
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.surfaceContainerDark,
    ),
  );
}
