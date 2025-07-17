import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/app/depends_providers.dart';
import 'package:yandex_school_homework/app/theme/app_theme.dart';
import 'package:yandex_school_homework/app/theme/theme_notifier.dart';
import 'package:yandex_school_homework/di/di_container.dart';
import 'package:yandex_school_homework/features/common/ui/splash_screen.dart';
import 'package:yandex_school_homework/features/error/error_screen.dart';

class App extends StatefulWidget {
  const App({super.key, required this.router, required this.initDependencies});

  final GoRouter router;
  final Future<DiContainer> Function() initDependencies;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late Future<DiContainer> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = widget.initDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DiContainer>(
      future: _initFuture,
      builder: (_, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const SplashScreen();
          case ConnectionState.done:
            if (snapshot.hasError) {
              return ErrorScreen(
                error: snapshot.error,
                stackTrace: snapshot.stackTrace,
                onRetry: _retryInit,
              );
            }

            final diContainer = snapshot.data;
            if (diContainer == null) {
              return ErrorScreen(
                error: 'Ошибка инициализации зависимостей, diContainer = null',
                stackTrace: null,
                onRetry: _retryInit,
              );
            }
            return DependsProviders(
              diContainer: diContainer,
              child: ThemeConsumer(builder: () => _App(router: widget.router)),
            );
        }
      },
    );
  }

  void _retryInit() {
    setState(() {
      _initFuture = widget.initDependencies();
    });
  }
}

class _App extends StatelessWidget {
  const _App({required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      darkTheme: AppTheme.dark,
      theme: AppTheme.light,
      themeMode: context.theme.themeMode,
    );
  }
}
