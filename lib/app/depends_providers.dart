import 'package:flutter/material.dart';
import 'package:yandex_school_homework/di/di_container.dart';
import 'package:provider/provider.dart';

final class DependsProviders extends StatelessWidget {
  const DependsProviders({
    super.key,
    required this.child,
    required this.diContainer,
  });

  final Widget child;
  final DiContainer diContainer;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [Provider.value(value: diContainer)],
      child: child,
    );
  }
}
