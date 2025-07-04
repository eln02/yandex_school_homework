import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/app/theme/app_colors_scheme.dart';
import 'package:yandex_school_homework/app/theme/texts_extension.dart';
import 'package:yandex_school_homework/features/common/ui/app_error_screen.dart';
import 'package:yandex_school_homework/features/common/ui/custom_app_bar.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/category_analysis_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/analysis_extension.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/transactions_cubit.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/transactions_state.dart';
import 'package:yandex_school_homework/features/transactions/presentation/componenets/date_filter_bar.dart';
import 'package:yandex_school_homework/features/transactions/presentation/componenets/diagram.dart';
import 'package:yandex_school_homework/features/transactions/presentation/componenets/total_amount_header.dart';
import 'package:yandex_school_homework/features/transactions/presentation/state/date_range_notifier.dart';
import 'package:yandex_school_homework/router/app_router.dart';

/// Экран анализа доходов/расходов
class TransactionsAnalysisScreen extends StatelessWidget {
  const TransactionsAnalysisScreen._({
    super.key,
    required this.isIncome,
    required this.startDate,
    required this.endDate,
  });

  final bool isIncome;
  final String startDate;
  final String endDate;

  /// Конструктор для экрана анализа расходов
  factory TransactionsAnalysisScreen.expenses({
    Key? key,
    required String startDate,
    required String endDate,
  }) {
    return TransactionsAnalysisScreen._(
      key: key,
      isIncome: false,
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Конструктор для экрана анализа доходов
  factory TransactionsAnalysisScreen.income({
    Key? key,
    required String startDate,
    required String endDate,
  }) {
    return TransactionsAnalysisScreen._(
      key: key,
      isIncome: true,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              // задается временной промежуток с предыдущего экрана
              DateRangeNotifier.fromStrings(
                startDate: startDate,
                endDate: endDate,
              ),
        ),
        BlocProvider(
          create: (context) =>
              TransactionsCubit(context.di.repositories.transactionsRepository),
        ),
      ],
      child: _TransactionsAnalysisView(isIncome: isIncome),
    );
  }
}

class _TransactionsAnalysisView extends StatefulWidget {
  const _TransactionsAnalysisView({required this.isIncome});

  final bool isIncome;

  @override
  State<_TransactionsAnalysisView> createState() =>
      _TransactionsAnalysisViewState();
}

class _TransactionsAnalysisViewState extends State<_TransactionsAnalysisView> {
  List<CategoryAnalysisEntity> _currentCategories = [];
  List<CategoryAnalysisEntity> _previousCategories = [];

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  /// Метод получения транзакций
  Future<void> _fetchTransactions() async {
    final dateNotifier = context.read<DateRangeNotifier>();
    context.read<TransactionsCubit>().fetchTransactions(
      // TODO: размокать accountId
      accountId: 140,
      startDate: dateNotifier.apiFormattedStartDate,
      endDate: dateNotifier.apiFormattedEndDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final diagramContainerSize = 190 * 906 / MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppBar(
        color: context.colors.mainBackground,
        title: 'Анализ ${widget.isIncome ? 'доходов' : 'расходов'}',
        showBackButton: true,
        extraHeight: 56 * 3 + diagramContainerSize,
        children: [
          Consumer<DateRangeNotifier>(
            builder: (context, notifier, _) => DateFilterBar(
              startDate: notifier.startDate,
              endDate: notifier.endDate,
              onDatesChanged: (start, end) {
                notifier.updateDateRange(startDate: start, endDate: end);
                _fetchTransactions();
              },
              color: context.colors.mainBackground,
              wrapData: true,
            ),
          ),
          BlocBuilder<TransactionsCubit, TransactionsState>(
            builder: (context, state) {
              return switch (state) {
                TransactionsLoadingState() => TotalAmountBar.loading(
                  title: 'Сумма',
                  isLast: false,
                  color: context.colors.mainBackground,
                ),
                TransactionsLoadedState() => TotalAmountBar(
                  totalAmount: widget.isIncome
                      ? state.incomesSum
                      : state.expensesSum,
                  currency: state.currency,
                  title: 'Сумма',
                  color: context.colors.mainBackground,
                  isLast: false,
                ),
                TransactionsErrorState() => TotalAmountBar(
                  totalAmount: 'Ошибка',
                  currency: null,
                  title: 'Сумма',
                  color: context.colors.mainBackground,
                  isLast: false,
                ),
              };
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            height: diagramContainerSize,
            child: BlocConsumer<TransactionsCubit, TransactionsState>(
              listener: (context, state) {
                if (state is TransactionsLoadedState) {
                  final newCategories = widget.isIncome
                      ? state.incomeCategoryList
                      : state.expenseCategoryList;

                  if (_currentCategories != newCategories) {
                    setState(() {
                      _previousCategories = _currentCategories;
                      _currentCategories = newCategories;
                    });
                  }
                }
              },
              builder: (context, state) {
                return switch (state) {
                  TransactionsLoadingState() when _currentCategories.isEmpty =>
                    AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        height: diagramContainerSize,
                        padding: const EdgeInsets.all(4),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox.expand(
                              child: CircularProgressIndicator(
                                strokeWidth: 8,
                                color: Colors.grey[300],
                              ),
                            ),
                            const Text('Загрузка графика'),
                          ],
                        ),
                      ),
                    ),
                  TransactionsErrorState() when _currentCategories.isEmpty =>
                    Center(
                      child: Text(
                        state.errorMessage,
                        style: context.texts.bodyMedium_,
                      ),
                    ),
                  _ => AnimatedPieChartSwitcher(
                    oldData: _previousCategories,
                    newData: _currentCategories,
                    animate:
                        state is TransactionsLoadedState &&
                        _previousCategories.isNotEmpty,
                  ),
                };
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<TransactionsCubit, TransactionsState>(
        builder: (context, state) {
          return switch (state) {
            TransactionsLoadingState() => const Center(
              child: CircularProgressIndicator(),
            ),
            TransactionsErrorState() => AppErrorScreen(
              errorMessage: state.errorMessage,
              onError: _fetchTransactions,
            ),
            TransactionsLoadedState() => _CategoryList(
              isIncome: widget.isIncome,
              categories: _currentCategories,
              currency: state.currency,
            ),
          };
        },
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({
    required this.isIncome,
    required this.categories,
    required this.currency,
  });

  final bool isIncome;
  final List<CategoryAnalysisEntity> categories;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: categories.length,
      separatorBuilder: (_, __) =>
          Divider(height: 1, color: context.colors.transactionsDivider),
      itemBuilder: (context, index) {
        final category = categories[index];
        return GestureDetector(
          onTap: () {
            context.pushNamed(
              isIncome
                  ? AppRouter.categoryTransactionsFromIncomes
                  : AppRouter.categoryTransactionsFromExpenses,
              extra: {'category': category},
            );
          },
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: context.colors.mainBackground,
            child: Row(
              children: [
                Text(category.emoji, style: context.texts.emoji),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(category.name, style: context.texts.bodyLarge_),
                      if (category.lastComment != null)
                        Text(
                          category.lastComment!,
                          style: context.texts.bodyMedium_.copyWith(
                            color: context.colors.onSurface_,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${category.percent.toStringAsFixed(0)}%'),
                    Text('${category.amount.toStringAsFixed(0)} $currency'),
                  ],
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: context.colors.labelsTertiary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
