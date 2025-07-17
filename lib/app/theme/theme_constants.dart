import 'dart:ui';

/// Класс для конфигурации цветов приложения
abstract class AppColors {
  // Light theme colors
  static const Color onSurfaceTextLight = Color(0xFF1D1B20);
  //static const Color onColoredBackgroundLight = Color(0xFFFFFFFF);
  static const Color lightFinanceGreenLight = Color(0xFFD4FAE6);
  static const Color mainBackgroundLight = Color(0xFFFEF7FF);
  static const Color surfaceContainerLight = Color(0xFFECE6F0);
  static const Color onSurfaceLight = Color(0xFF49454F);
  static const Color transactionsDividerLight = Color(0xFFCAC4D0);
  static const Color shimmerContainerLight = Color(0xFFB8F5D5);
  static const Color modalLineLight = Color(0xFF79747E);
  static const Color labelsTertiaryLight = Color(0x4D3C3C43); // 30% opacity

  // Dark theme colors
  static const Color onSurfaceTextDark = Color(0xFFE6E0E9);
  static const Color onColoredBackgroundDark = Color(0xFF1D1B20);
  static const Color lightFinanceGreenDark = Color(0xFF1E3A2F);
  static const Color mainBackgroundDark = Color(0xFF141218);
  static const Color surfaceContainerDark = Color(0xFF211F26);
  static const Color onSurfaceDark = Color(0xFFCAC4D0);
  static const Color transactionsDividerDark = Color(0xFF49454F);
  static const Color shimmerContainerDark = Color(0xFF1E3A2F);
  static const Color modalLineDark = Color(0xFF938F99);
  static const Color labelsTertiaryDark = Color(0x4DE6E0E9); // 30% opacity

  // Common colors (same for both themes)
  static const Color financeGreen = Color(0xFF2AE881);
  static const Color white = Color(0xFFFFFFFF);
}
