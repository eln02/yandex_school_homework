import 'package:flutter/material.dart';

// TODO: установить шрифт локально для поддержки на ios
const String roboto = 'Roboto';

extension TextStyleScheme on TextTheme {
  TextStyle get bodyLarge_ => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    letterSpacing: 0.5,
    fontFamily: roboto,
  );

  TextStyle get bodySmall_ => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 18 / 12,
    letterSpacing: 0.5,
    fontFamily: roboto,
  );

  TextStyle get bodyMedium_ => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    letterSpacing: 0.25,
    fontFamily: roboto,
  );

  TextStyle get titleLarge_ => const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    height: 28 / 22,
    letterSpacing: 0,
    fontFamily: roboto,
  );

  TextStyle get emoji => const TextStyle(fontSize: 24);
}
