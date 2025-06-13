import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef ThemeBuilder = Widget Function();

class ThemeConsumer extends StatelessWidget {
  const ThemeConsumer({super.key, required this.builder});

  final ThemeBuilder builder;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (_, __, ___) {
        return builder();
      },
    );
  }
}

final class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void changeTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }
}
