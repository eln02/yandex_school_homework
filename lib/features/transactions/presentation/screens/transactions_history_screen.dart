import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/features/common/ui/app_error_screen.dart';
import 'package:yandex_school_homework/features/common/ui/custom_app_bar.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/sorting_enum.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/transactions_cubit.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/transactions_state.dart';
import 'package:yandex_school_homework/features/transactions/presentation/componenets/date_filter_bar.dart';
import 'package:yandex_school_homework/features/transactions/presentation/componenets/sorting_bar.dart';
import 'package:yandex_school_homework/features/transactions/presentation/componenets/total_amount_header.dart';
import 'package:yandex_school_homework/features/transactions/presentation/componenets/transactions_list.dart';
import 'package:yandex_school_homework/features/transactions/presentation/state/date_range_notifier.dart';
import 'package:yandex_school_homework/router/app_router.dart';

/// Экран с историей доходов/расходов
class TransactionsHistoryScreen extends StatelessWidget {
  const TransactionsHistoryScreen._({super.key, required this.isIncome});

  final bool isIncome;

  /// Конструктор для экрана с расходами
  factory TransactionsHistoryScreen.expenses({Key? key}) {
    return TransactionsHistoryScreen._(key: key, isIncome: false);
  }

  /// Конструктор для экрана с доходами
  factory TransactionsHistoryScreen.income({Key? key}) {
    return TransactionsHistoryScreen._(key: key, isIncome: true);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DateRangeNotifier.lastMonth()),
        // локальный кубит транзакций внутри экрана (отдельное состояние от глобального)
        BlocProvider(
          create: (context) =>
              TransactionsCubit(context.di.repositories.transactionsRepository),
        ),
      ],
      child: _TransactionsHistoryView(isIncome: isIncome),
    );
  }
}

class _TransactionsHistoryView extends StatefulWidget {
  const _TransactionsHistoryView({required this.isIncome});

  final bool isIncome;

  @override
  State<_TransactionsHistoryView> createState() =>
      _TransactionsHistoryViewState();
}

class _TransactionsHistoryViewState extends State<_TransactionsHistoryView> {
  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  /// Метод получения транзакций
  Future<void> _fetchTransactions() async {
    final dateNotifier = context.read<DateRangeNotifier>();
    context.read<TransactionsCubit>().fetchTransactions(
      // TODO: размокать accountId когда появится логика аккаунтов
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
          TransactionsLoadedState() => _TransactionsHistorySuccessScreen(
            isIncome: widget.isIncome,
            state: state,
            onRefresh: _fetchTransactions,
          ),
        };
      },
    );
  }
}

class _TransactionsHistorySuccessScreen extends StatelessWidget {
  _TransactionsHistorySuccessScreen({
    required this.isIncome,
    required this.state,
    required this.onRefresh,
  });

  final bool isIncome;
  final TransactionsLoadedState state;
  final Future<void> Function() onRefresh;

  /// ValueNotifier для определения типа сортировки
  final sortingTypeNotifier = ValueNotifier<SortingType>(SortingType.none);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackButton: true,
        title: 'История ${isIncome ? 'доходов' : 'расходов'}',
        onNext: () {
          final dateNotifier = context.read<DateRangeNotifier>();
          // переход на экран анализа с сохранением выбранного временного промежутка
          context.pushNamed(
            isIncome ? AppRouter.incomeAnalysis : AppRouter.expensesAnalysis,
            queryParameters: {
              'startDate': dateNotifier.uiFormattedStartDate,
              'endDate': dateNotifier.uiFormattedEndDate,
            },
          );
        },
        // TODO: скачать иконку с макета
        icon: const Icon(Icons.assignment_outlined),
        extraHeight: 56 * 4,
        children: [
          Consumer<DateRangeNotifier>(
            builder: (context, notifier, _) => DateFilterBar(
              startDate: notifier.startDate,
              endDate: notifier.endDate,
              onDatesChanged: (start, end) {
                notifier.updateDateRange(startDate: start, endDate: end);
                onRefresh();
              },
            ),
          ),

          SortingBar(
            currentSorting: sortingTypeNotifier.value,
            onSortingChanged: (type) {
              sortingTypeNotifier.value = type;
            },
          ),

          TotalAmountBar(
            totalAmount: isIncome ? state.incomesSum : state.expensesSum,
            currency: state.currency,
            title: 'Сумма',
          ),
        ],
      ),
      body: ValueListenableBuilder<SortingType>(
        valueListenable: sortingTypeNotifier,
        builder: (context, sorting, child) {
          return TransactionsList(
            transactions: isIncome
                ? state.sortedIncomes(sorting)
                : state.sortedExpenses(sorting),
            onRefresh: onRefresh,
          );
        },
      ),
    );
  }
}
