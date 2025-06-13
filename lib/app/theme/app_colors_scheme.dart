import 'package:flutter/material.dart';

extension AppColorsScheme on ColorScheme {
  bool get _isLight => brightness == Brightness.light;

  Color get testColor => _isLight ? Colors.green : Colors.red;

  Color get surfaceContainer_ =>
      _isLight ? const Color(0xFFF3EDF7) : const Color(0xFFF3EDF7);

  Color get onSurface_ =>
      _isLight ? const Color(0xFF49454F) : const Color(0xFF49454F);

  Color get financeGreen =>
      _isLight ? const Color(0xFF2AE881) : const Color(0xFF2AE881);

  Color get lightFinanceGreen =>
      _isLight ? const Color(0xFFD4FAE6) : const Color(0xFFD4FAE6);
}
