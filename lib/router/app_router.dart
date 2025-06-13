import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_school_homework/features/debug/debug_screen.dart';
import 'package:yandex_school_homework/features/debug/i_debug_service.dart';
import 'package:yandex_school_homework/router/root_screen.dart';

class AppRouter {
  const AppRouter();

  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static String get initialLocation => '/debug';

  static GoRouter createRouter(IDebugService debugService) {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      debugLogDiagnostics: true,
      initialLocation: initialLocation,
      routes: [
        StatefulShellRoute.indexedStack(
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state, navigationShell) =>
              RootScreen(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/debug',
                  name: 'debug',
                  builder: (context, state) => const DebugScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/2',
                  name: '2',
                  builder: (context, state) =>
                      const Center(child: Text('2 страница')),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
