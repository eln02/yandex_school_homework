import 'package:flutter/material.dart';
import 'package:yandex_school_homework/app/theme/theme_notifier.dart';
import 'package:provider/provider.dart';

final class AppProviders extends StatelessWidget {
  const AppProviders({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ThemeNotifier())],
      child: child,
    );
  }
}
