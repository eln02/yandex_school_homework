import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/cash_flow_analysis_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/daily_analysis_extension.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/transactions_cubit.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/transactions_state.dart';

class TransactionsDiagram extends StatelessWidget {
  const TransactionsDiagram({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TransactionsCubit(context.di.repositories.transactionsRepository),
      child: const _TransactionsDiagramView(),
    );
  }
}

class _TransactionsDiagramView extends StatefulWidget {
  const _TransactionsDiagramView();

  @override
  State<_TransactionsDiagramView> createState() =>
      _TransactionsDiagramViewState();
}

class _TransactionsDiagramViewState extends State<_TransactionsDiagramView> {
  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  /// Метод получения транзакций
  Future<void> _fetchTransactions() async {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    context.read<TransactionsCubit>().fetchTransactions(
      // TODO: размокать accountId когда появится логика аккаунтов
      accountId: 140,
      startDate: DateFormat('yyyy-MM-dd').format(thirtyDaysAgo),
      endDate: DateFormat('yyyy-MM-dd').format(now),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: BlocBuilder<TransactionsCubit, TransactionsState>(
        builder: (context, state) {
          return switch (state) {
            TransactionsLoadingState() => const Center(
              child: CircularProgressIndicator(),
            ),
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
                  onPressed: _fetchTransactions,
                  child: const Text('Повторить попытку'),
                ),
              ],
            ),
            TransactionsLoadedState() => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CashFlowChart(data: state.dailyCashFlowLast30Days),
            ),
          };
        },
      ),
    );
  }
}

class CashFlowChart extends StatefulWidget {
  final List<CashFlowAnalysisEntity> data;

  const CashFlowChart({super.key, required this.data});

  @override
  State<CashFlowChart> createState() => _CashFlowChartState();
}

class _CashFlowChartState extends State<CashFlowChart> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: _calculateMaxY(widget.data),
              minY: _calculateMinY(widget.data),
              groupsSpace: 10,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final dayData = widget.data[group.x.toInt()];
                    return BarTooltipItem(
                      '${dayData.flow.toStringAsFixed(2)} ₽',
                      const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: '\n${_formatDate(dayData.date)}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  },
                  tooltipMargin: 10,
                  tooltipBorder: const BorderSide(color: Colors.black),
                  tooltipPadding: const EdgeInsets.all(8),
                  direction: TooltipDirection.top,
                  getTooltipColor: (group) => Colors.white,
                ),
                touchCallback: (event, response) {
                  if (!event.isInterestedForInteractions ||
                      response == null ||
                      response.spot == null) {
                    setState(() => touchedIndex = null);
                    return;
                  }
                  setState(() {
                    touchedIndex = response.spot!.touchedBarGroupIndex;
                  });
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: _getBottomTitles,
                    reservedSize: 24,
                  ),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: widget.data.asMap().entries.map((entry) {
                final index = entry.key;
                final dayData = entry.value;
                final isTouched = index == touchedIndex;

                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: dayData.flow.abs(),
                      color: isTouched
                          ? Colors.amber
                          : dayData.flow < 0
                          ? Colors.red
                          : Colors.green,
                      width: 8,
                      borderRadius: BorderRadius.zero,
                    ),
                  ],
                  showingTooltipIndicators: isTouched ? [0] : [],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  double _calculateMaxY(List<CashFlowAnalysisEntity> data) {
    final maxFlow = data
        .map((e) => e.flow.abs())
        .reduce((a, b) => a > b ? a : b);
    return maxFlow * 1.2; // Добавляем 20% отступа
  }

  double _calculateMinY(List<CashFlowAnalysisEntity> data) {
    return 0;
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index == 0 ||
        index == widget.data.length ~/ 2 ||
        index == widget.data.length - 1) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          _formatDate(widget.data[index].date),
          style: const TextStyle(fontSize: 10),
        ),
      );
    }
    return const SizedBox();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}';
  }
}
