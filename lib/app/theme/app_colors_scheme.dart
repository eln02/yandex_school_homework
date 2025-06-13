import 'package:flutter/material.dart';

extension AppColorsScheme on ColorScheme {
  bool get _isLight => brightness == Brightness.light;

  Color get testColor => _isLight ? Colors.green : Colors.red;
}
