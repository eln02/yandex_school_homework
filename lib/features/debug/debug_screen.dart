import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/cash_flow_analysis_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/daily_analysis_extension.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/transactions_cubit.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/transactions_state.dart';
import 'package:intl/intl.dart';
import 'package:yandex_school_homework/features/transactions/presentation/componenets/transactions_diagram.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TransactionsCubit(context.di.repositories.transactionsRepository),
      child: const _DebugScreenView(),
    );
  }
}

class _DebugScreenView extends StatefulWidget {
  const _DebugScreenView();

  @override
  State<_DebugScreenView> createState() => _DebugScreenViewState();
}

class _DebugScreenViewState extends State<_DebugScreenView> {
  bool _showMonthly = false;
  bool _initialLoadComplete = false;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    final now = DateTime.now();
    // Загружаем данные за последний год (покроет и 30 дней и 12 месяцев)
    final startDate = DateTime(now.year - 1, now.month, now.day);

    await context.read<TransactionsCubit>().fetchTransactions(
      accountId: 140,
      startDate: DateFormat('yyyy-MM-dd').format(startDate),
      endDate: DateFormat('yyyy-MM-dd').format(now),
    );

    setState(() {
      _initialLoadComplete = true;
    });
  }

  String _formatDisplayDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Отладка графика'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchInitialData,
          ),
        ],
      ),
      body: BlocBuilder<TransactionsCubit, TransactionsState>(
        builder: (context, state) {
          if (!_initialLoadComplete && state is TransactionsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          return switch (state) {
            TransactionsErrorState(errorMessage: final message) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ошибка: $message',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _fetchInitialData,
                  child: const Text('Повторить попытку'),
                ),
              ],
            ),
            TransactionsLoadedState() => SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Переключатель между днями и месяцами
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ToggleButtons(
                      isSelected: [!_showMonthly, _showMonthly],
                      onPressed: (index) {
                        setState(() {
                          _showMonthly = index == 1;
                        });
                      },
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('По дням'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('По месяцам'),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _showMonthly
                        ? 'График денежного потока за последние 12 месяцев'
                        : 'График денежного потока за последние 30 дней',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      height: 250,
                      child: CashFlowChart(
                        data: _showMonthly
                            ? state.monthlyCashFlowLast12Months
                            : state.dailyCashFlowLast30Days,
                        isMonthly: _showMonthly,
                        currency: state.currency,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildDataTable(
                      _showMonthly
                          ? state.monthlyCashFlowLast12Months
                          : state.dailyCashFlowLast30Days,
                    ),
                  ),
                ],
              ),
            ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }

  Widget _buildDataTable(List<CashFlowAnalysisEntity> data) {
    return DataTable(
      columns: [
        DataColumn(label: Text(_showMonthly ? 'Месяц' : 'Дата')),
        const DataColumn(label: Text('Баланс'), numeric: true),
      ],
      rows: data.map((item) {
        return DataRow(
          cells: [
            DataCell(
              Text(
                _showMonthly
                    ? DateFormat('MMMM yyyy', 'ru_RU').format(item.date)
                    : _formatDisplayDate(item.date),
              ),
            ),
            DataCell(
              Text(
                NumberFormat.currency(
                  symbol: '₽',
                  decimalDigits: 2,
                  locale: 'ru_RU',
                ).format(item.flow),
                style: TextStyle(
                  color: item.flow < 0 ? Colors.red : Colors.green,
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
