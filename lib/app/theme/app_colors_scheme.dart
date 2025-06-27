import 'package:flutter/material.dart';
import 'package:yandex_school_homework/app/theme/theme_constants.dart';

extension AppColorsScheme on ColorScheme {
  bool get _isLight => brightness == Brightness.light;

  Color get testColor => _isLight ? Colors.green : Colors.red;

  Color get white => Colors.white;

  Color get mainBackground =>
      _isLight ? AppColors.mainBackground : AppColors.mainBackground;

  Color get surfaceContainer_ =>
      _isLight ? const Color(0xFFF3EDF7) : const Color(0xFFF3EDF7);

  Color get onSurface_ =>
      _isLight ? const Color(0xFF49454F) : const Color(0xFF49454F);

  Color get financeGreen =>
      _isLight ? const Color(0xFF2AE881) : const Color(0xFF2AE881);

  Color get lightFinanceGreen =>
      _isLight ? const Color(0xFFD4FAE6) : const Color(0xFFD4FAE6);

  Color get transactionsDivider =>
      _isLight ? const Color(0xFFCAC4D0) : const Color(0xFFCAC4D0);

  Color get onSurfaceText =>
      _isLight ? const Color(0xFF1D1B20) : const Color(0xFF1D1B20);

  // withAlpha(77) = 30% прозрачность
  Color get labelsTertiary => _isLight
      ? const Color(0xFF3C3C43).withAlpha(77)
      : const Color(0xFF3C3C43).withAlpha(77);

  Color get surfaceContainer =>
      _isLight ? const Color(0xFFECE6F0) : const Color(0xFFECE6F0);

  Color get modalLine =>
      _isLight ? const Color(0xFF79747E) : const Color(0xFF79747E);
}
