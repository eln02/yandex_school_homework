import 'package:flutter/material.dart';
import 'package:yandex_school_homework/app/theme/theme_constants.dart';

extension AppColorsScheme on ColorScheme {
  bool get _isLight => brightness == Brightness.light;

  Color get testColor => _isLight ? Colors.green : Colors.red;

  Color get white => AppColors.white;

  Color get mainBackground =>
      _isLight ? AppColors.mainBackgroundLight : AppColors.mainBackgroundDark;

  Color get surfaceContainer_ => _isLight
      ? AppColors.surfaceContainerLight
      : AppColors.surfaceContainerDark;

  Color get onSurface_ =>
      _isLight ? AppColors.onSurfaceLight : AppColors.onSurfaceDark;

  Color get onColoredBackground_ => AppColors.onColoredBackgroundDark;

  Color get financeGreen => AppColors.financeGreen;

  Color get secondFinanceGreen => _isLight
      ? AppColors.lightFinanceGreenLight
      : AppColors.lightFinanceGreenDark;

  Color get transactionsDivider => _isLight
      ? AppColors.transactionsDividerLight
      : AppColors.transactionsDividerDark;

  Color get onSurfaceText =>
      _isLight ? AppColors.onSurfaceTextLight : AppColors.onSurfaceTextDark;

  Color get labelsTertiary =>
      _isLight ? AppColors.labelsTertiaryLight : AppColors.labelsTertiaryDark;

  Color get surfaceContainer => _isLight
      ? AppColors.surfaceContainerLight
      : AppColors.surfaceContainerDark;

  Color get modalLine =>
      _isLight ? AppColors.modalLineLight : AppColors.modalLineDark;

  Color get shimmerContainer => _isLight
      ? AppColors.shimmerContainerLight
      : AppColors.shimmerContainerDark;
}
