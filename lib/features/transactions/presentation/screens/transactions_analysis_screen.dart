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
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/analysis_extension.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/transactions_cubit.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/transactions_state.dart';
import 'package:yandex_school_homework/features/transactions/presentation/componenets/date_filter_bar.dart';
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
      accountId: 1,
      startDate: dateNotifier.apiFormattedStartDate,
      endDate: dateNotifier.apiFormattedEndDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsCubit, TransactionsState>(
      builder: (context, state) {
        return switch (state) {
          TransactionsLoadingState() => const Center(
            child: CircularProgressIndicator(),
          ),
          TransactionsErrorState() => AppErrorScreen(
            errorMessage: state.errorMessage,
            onError: _fetchTransactions,
          ),
          TransactionsLoadedState() => _TransactionsAnalysisSuccessScreen(
            isIncome: widget.isIncome,
            state: state,
            onRefresh: _fetchTransactions,
          ),
        };
      },
    );
  }
}

class _TransactionsAnalysisSuccessScreen extends StatelessWidget {
  const _TransactionsAnalysisSuccessScreen({
    required this.isIncome,
    required this.state,
    required this.onRefresh,
  });

  final bool isIncome;
  final TransactionsLoadedState state;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        color: context.colors.mainBackground,
        title: 'Анализ ${isIncome ? 'доходов' : 'расходов'}',
        showBackButton: true,
        extraHeight: 56 * 3,
        children: [
          Consumer<DateRangeNotifier>(
            builder: (context, notifier, _) => DateFilterBar(
              startDate: notifier.startDate,
              endDate: notifier.endDate,
              onDatesChanged: (start, end) {
                notifier.updateDateRange(startDate: start, endDate: end);
                onRefresh();
              },
              color: context.colors.mainBackground,
              wrapData: true,
            ),
          ),

          TotalAmountBar(
            totalAmount: isIncome ? state.incomesSum : state.expensesSum,
            currency: state.currency,
            title: 'Сумма',
            color: context.colors.mainBackground,
            isLast: false,
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: isIncome
            ? state.incomeCategoryEntries.length
            : state.expenseCategoryEntries.length,
        separatorBuilder: (_, __) =>
            Divider(height: 1, color: context.colors.transactionsDivider),
        itemBuilder: (context, index) {
          final entry = isIncome
              ? state.incomeCategoryEntries[index]
              : state.expenseCategoryEntries[index];

          final CategoryAnalysisEntity category = entry.key;
          final List<TransactionResponseEntity> transactions = entry.value;

          return GestureDetector(
            onTap: () {
              context.pushNamed(
                isIncome
                    ? AppRouter.categoryTransactionsFromIncomes
                    : AppRouter.categoryTransactionsFromExpenses,
                extra: {'category': category, 'transactions': transactions},
              );
            },
            child: Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: context.colors.mainBackground,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                      Text(
                        '${category.amount.toStringAsFixed(0)} ${state.currency}',
                      ),
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
      ),
    );
  }
}
