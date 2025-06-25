import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_school_homework/features/accounts/presentation/screens/account_screen.dart';
import 'package:yandex_school_homework/features/debug/i_debug_service.dart';
import 'package:yandex_school_homework/features/transactions/presentation/screens/transactions_history_screen.dart';
import 'package:yandex_school_homework/features/transactions/presentation/screens/transactions_screen.dart';
import 'package:yandex_school_homework/router/root_screen.dart';

class AppRouter {
  const AppRouter();

  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static String get initialLocation => '/expenses_path';

  static String get expensesHistory => '/expenses_history_name';

  static String get incomeHistory => '/income_history_name';

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
                  path: initialLocation,
                  name: 'expenses',
                  builder: (context, state) => TransactionsScreen.expenses(),
                  routes: [
                    GoRoute(
                      path: 'expenses_history',
                      name: expensesHistory,
                      builder: (context, state) =>
                          TransactionsHistoryScreen.expenses(),
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/income_path',
                  name: 'income',
                  builder: (context, state) => TransactionsScreen.income(),
                  routes: [
                    GoRoute(
                      path: 'income_history',
                      name: incomeHistory,
                      builder: (context, state) =>
                          TransactionsHistoryScreen.income(),
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/account_path',
                  name: 'account',
                  builder: (context, state) => const AccountScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/items_path',
                  name: 'items',
                  builder: (context, state) =>
                      const Center(child: Text('Тут статьи будут')),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/settings_path',
                  name: 'settings',
                  builder: (context, state) =>
                      const Center(child: Text('Тут настройки будут')),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
