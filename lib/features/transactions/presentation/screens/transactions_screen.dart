import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/app/theme/app_colors_scheme.dart';
import 'package:yandex_school_homework/features/common/ui/app_error_screen.dart';
import 'package:yandex_school_homework/features/common/ui/custom_app_bar.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/sorting_enum.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/transaction/transaction_state.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/transaction/transacton_cubit.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/transactions_cubit.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/transactions_state.dart';
import 'package:yandex_school_homework/features/transactions/presentation/componenets/total_amount_header.dart';
import 'package:yandex_school_homework/features/transactions/presentation/componenets/transactions_list.dart';
import 'package:yandex_school_homework/features/transactions/presentation/screens/transaction_modal_screen.dart';
import 'package:yandex_school_homework/router/app_router.dart';

/// Экран с доходами/расходами
class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen._({super.key, this.isIncome = false});

  final bool isIncome;

  /// Конструктор для экрана с расходами
  factory TransactionsScreen.expenses({Key? key}) {
    return TransactionsScreen._(key: key, isIncome: false);
  }

  /// Конструктор для экрана с доходами
  factory TransactionsScreen.income({Key? key}) {
    return TransactionsScreen._(key: key, isIncome: true);
  }

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  void initState() {
    super.initState();
    // защита от повторной загрузки на втором экране т.к. стейт общий
    if (context.read<TransactionsCubit>().state is! TransactionsLoadedState) {
      _fetchTransactions();
    }
  }

  /// Метод получения транзакций
  Future<void> _fetchTransactions() async {
    final now = DateTime.now().toUtc();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);

    context.read<TransactionsCubit>().fetchTransactions(
      // TODO: размокать accountId когда появится логика аккаунтов
      accountId: 140,
      startDate: formattedDate,
      endDate: formattedDate,
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
          TransactionsLoadedState() => _TransactionsSuccessScreen(
            isIncome: widget.isIncome,
            state: state,
            onRefresh: _fetchTransactions,
          ),
        };
      },
    );
  }
}

class _TransactionsSuccessScreen extends StatelessWidget {
  const _TransactionsSuccessScreen({
    required this.isIncome,
    required this.state,
    required this.onRefresh,
  });

  final bool isIncome;
  final TransactionsLoadedState state;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionOperationCubit, TransactionOperationState>(
      listener: (context, state) {
        switch (state) {
          /// Добавление новой транзакции
          case TransactionOperationSuccessState():
            onRefresh();

          /// Обновление транзакции
          case TransactionOperationUpdateState():
            onRefresh();

          /// Удаление транзакции
          case TransactionOperationDeleteState():
            onRefresh();

          case TransactionOperationFailure():
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Ошибка: ${state.error}')));

          default:
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          extraHeight: 56,
          title: '${isIncome ? 'Доходы' : 'Расходы'} сегодня',
          onNext: () => context.pushNamed(
            isIncome ? AppRouter.incomeHistory : AppRouter.expensesHistory,
          ),
          nextIcon: const Icon(Icons.history),
          children: [
            TotalAmountBar(
              totalAmount: isIncome ? state.incomesSum : state.expensesSum,
              currency: state.currency,
              title: 'Всего',
            ),
          ],
        ),
        body: Stack(
          children: [
            TransactionsList(
              transactions: isIncome
                  ? state.sortedIncomes(SortingType.dateNewestFirst)
                  : state.sortedExpenses(SortingType.dateNewestFirst),
              onRefresh: onRefresh,
              onTapTransaction: (transaction) async {
                final updatedTransaction = await showTransactionEditModal(
                  context: context,
                  transaction: transaction,
                );

                /// Удаление транзакции
                if (updatedTransaction == null && context.mounted) {
                  context.read<TransactionOperationCubit>().deleteTransaction(
                    transaction.id,
                  );
                }

                /// Обновление транзакции
                if (updatedTransaction != null && context.mounted) {
                  context.read<TransactionOperationCubit>().updateTransaction(
                    transaction: updatedTransaction,
                    transactionId: transaction.id,
                  );
                }
              },
            ),
            _FloatingButton(
              onTap: () async {
                final newTransaction = await showTransactionEditModal(
                  context: context,
                  isIncome: isIncome,
                );
                if (newTransaction != null && context.mounted) {
                  context.read<TransactionOperationCubit>().createTransaction(
                    newTransaction,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingButton extends StatelessWidget {
  const _FloatingButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 14,
      child: SizedBox(
        width: 56,
        height: 56,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colors.financeGreen,
            shape: const CircleBorder(),
            padding: EdgeInsets.zero,
            elevation: 0,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
          ),
          child: Icon(Icons.add, color: context.colors.white, size: 24),
        ),
      ),
    );
  }
}
