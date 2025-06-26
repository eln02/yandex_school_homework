import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_school_homework/features/accounts/presentation/screens/account_screen.dart';
import 'package:yandex_school_homework/features/categories/presentation/screens/categories_screen.dart';
import 'package:yandex_school_homework/features/categories/presentation/screens/search_categories_screen.dart';
import 'package:yandex_school_homework/features/debug/i_debug_service.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/category_analysis_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';
import 'package:yandex_school_homework/features/transactions/presentation/screens/transactions_analysis_screen.dart';
import 'package:yandex_school_homework/features/transactions/presentation/screens/transactions_by_category_screen.dart';
import 'package:yandex_school_homework/features/transactions/presentation/screens/transactions_history_screen.dart';
import 'package:yandex_school_homework/features/transactions/presentation/screens/transactions_screen.dart';
import 'package:yandex_school_homework/router/root_screen.dart';

class AppRouter {
  const AppRouter();

  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static String get initialLocation => '/expenses_path';

  static String get expensesHistory => '/expenses_history_name';

  static String get incomeHistory => '/income_history_name';

  static String get expensesAnalysis => '/expenses_analysis_name';

  static String get incomeAnalysis => '/income_analysis_name';

  static String get categoryTransactionsFromIncomes =>
      '/category_transactions_from_incomes_name';

  static String get categoryTransactionsFromExpenses =>
      '/category_transactions_from_expense_name';

  static String get searchCategories => '/search_categories_name';

  static GoRouter createRouter(IDebugService debugService) {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      debugLogDiagnostics: true,
      initialLocation: initialLocation,
      routes: [
        // TODO: вынести ветки в отдельные классы
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
                      routes: [
                        GoRoute(
                          path: 'expenses_analysis',
                          name: expensesAnalysis,
                          builder: (context, state) {
                            final startDate =
                                state.uri.queryParameters['startDate'] ?? '';
                            final endDate =
                                state.uri.queryParameters['endDate'] ?? '';
                            return TransactionsAnalysisScreen.expenses(
                              startDate: startDate,
                              endDate: endDate,
                            );
                          },
                          routes: [
                            GoRoute(
                              path: 'category_transactions',
                              name: categoryTransactionsFromIncomes,
                              builder: (context, state) {
                                // TODO: что-то с этим сделать
                                final extra =
                                    state.extra as Map<String, Object>;
                                final category =
                                    extra['category'] as CategoryAnalysisEntity;
                                final transactions =
                                    extra['transactions']
                                        as List<TransactionResponseEntity>;

                                return TransactionsByCategoryScreen(
                                  category: category,
                                  transactions: transactions,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
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
                      routes: [
                        GoRoute(
                          path: 'income_analysis',
                          name: incomeAnalysis,
                          builder: (context, state) {
                            final startDate =
                                state.uri.queryParameters['startDate'] ?? '';
                            final endDate =
                                state.uri.queryParameters['endDate'] ?? '';
                            return TransactionsAnalysisScreen.income(
                              startDate: startDate,
                              endDate: endDate,
                            );
                          },
                          routes: [
                            GoRoute(
                              path: 'category_transactions',
                              name: categoryTransactionsFromExpenses,
                              builder: (context, state) {
                                // TODO: что-то с этим сделать
                                final extra =
                                    state.extra as Map<String, Object>;
                                final category =
                                    extra['category'] as CategoryAnalysisEntity;
                                final transactions =
                                    extra['transactions']
                                        as List<TransactionResponseEntity>;

                                return TransactionsByCategoryScreen(
                                  category: category,
                                  transactions: transactions,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
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
                  path: '/categories_path',
                  name: 'categories',
                  builder: (context, state) => const CategoriesScreen(),
                  routes: [
                    GoRoute(
                      path: 'search_categories',
                      name: searchCategories,
                      builder: (context, state) =>
                          const SearchCategoriesScreen(),
                    ),
                  ],
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
