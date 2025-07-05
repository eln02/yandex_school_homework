import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/app/theme/app_colors_scheme.dart';
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ToggleButtons(
              isSelected: [!_showMonthly, _showMonthly],
              onPressed: (index) {
                setState(() {
                  _showMonthly = index == 1;
                });
              },
              selectedColor: Colors.white,
              fillColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return context.colors.financeGreen;
                }
                return Colors.transparent;
              }),
              borderColor: context.colors.financeGreen,
              selectedBorderColor: context.colors.financeGreen,
              borderRadius: BorderRadius.circular(8),
              borderWidth: 1,
              splashColor: Colors.transparent,
              constraints: const BoxConstraints(minHeight: 40, minWidth: 100),
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
          Expanded(
            child: BlocBuilder<TransactionsCubit, TransactionsState>(
              builder: (context, state) {
                if (!_initialLoadComplete &&
                    state is TransactionsLoadingState) {
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
                  TransactionsLoadedState() => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CashFlowChart(
                      data: _showMonthly
                          ? state.monthlyCashFlowLast12Months
                          : state.dailyCashFlowLast30Days,
                      isMonthly: _showMonthly,
                      currency: state.currency, // Передаем валюту из состояния
                    ),
                  ),
                  _ => const SizedBox.shrink(),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CashFlowChart extends StatefulWidget {
  final List<CashFlowAnalysisEntity> data;
  final bool isMonthly;
  final String currency;

  const CashFlowChart({
    super.key,
    required this.data,
    this.isMonthly = false,
    required this.currency,
  });

  @override
  State<CashFlowChart> createState() => _CashFlowChartState();
}

class _CashFlowChartState extends State<CashFlowChart> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: _calculateMaxY(widget.data),
              minY: _calculateMinY(widget.data),
              groupsSpace: widget.isMonthly ? 16 : 10,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final dayData = widget.data[group.x.toInt()];
                    return BarTooltipItem(
                      _formatCurrency(dayData.flow),
                      // Используем форматирование с валютой
                      const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: '\n${_formatTooltipDate(dayData.date)}',
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
                    reservedSize: 28,
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
                          ? const Color(0xFFFF5F00)
                          : const Color(0xFF2AE881),
                      width: widget.isMonthly ? 12 : 8,
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

  // Новый метод для форматирования суммы с учетом валюты
  String _formatCurrency(double amount) {
    return '${NumberFormat.decimalPattern().format(amount)} ${widget.currency}';
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
    final showTitle = widget.isMonthly
        ? index % (widget.data.length > 6 ? 2 : 1) == 0
        : index == 0 ||
              index == widget.data.length ~/ 2 ||
              index == widget.data.length - 1;

    if (showTitle && index < widget.data.length) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          widget.isMonthly
              ? _formatMonth(widget.data[index].date)
              : _formatDay(widget.data[index].date),
          style: const TextStyle(fontSize: 10, color: Colors.black),
        ),
      );
    }
    return const SizedBox();
  }

  String _formatDay(DateTime date) {
    return DateFormat('dd.MM').format(date);
  }

  String _formatMonth(DateTime date) {
    return DateFormat('MMM yy', 'ru_RU').format(date);
  }

  String _formatTooltipDate(DateTime date) {
    return widget.isMonthly
        ? DateFormat('MMMM yyyy', 'ru_RU').format(date)
        : DateFormat('dd.MM.yyyy').format(date);
  }
}
