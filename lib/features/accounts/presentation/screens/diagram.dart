import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class BarChartSample extends StatefulWidget {
  const BarChartSample({super.key});

  @override
  _BarChartSampleState createState() => _BarChartSampleState();
}

class _BarChartSampleState extends State<BarChartSample> {
  final Random _random = Random();
  List<double> values = [];
  late List<String> dates;
  late List<bool> isNegative;
  int? touchedIndex;

  @override
  void initState() {
    super.initState();
    // Генерируем 30 случайных значений от -100 до 100
    values = List.generate(
      30,
      (_) => (_random.nextDouble() * 200 - 100).roundToDouble(),
    );
    isNegative = values.map((value) => value < 0).toList();

    // Генерируем даты текущего месяца
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    dates = List.generate(30, (i) {
      final date = firstDay.add(Duration(days: i));
      return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}';
    });
  }

  Widget getBottomTitleWidgets(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index == 0 || index == 14 || index == 29) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          dates[index],
          style: const TextStyle(fontSize: 10, color: Colors.black),
        ),
      );
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        minY: 0,
        groupsSpace: 10,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                values[group.x.toInt()].toStringAsFixed(0),
                const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: '\n${dates[group.x.toInt()]}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                ],
              );
            },
            tooltipBorder: const BorderSide(color: Colors.grey),
            tooltipMargin: 10,
            tooltipPadding: const EdgeInsets.all(8),
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            direction: TooltipDirection.top,
            maxContentWidth: 120,
            getTooltipColor: (group) => Colors.white,
          ),
          touchCallback: (FlTouchEvent event, barTouchResponse) {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              setState(() => touchedIndex = null);
              return;
            }
            setState(() {
              touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
            });
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getBottomTitleWidgets,
              reservedSize: 24,
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(30, (index) {
          final isTouched = index == touchedIndex;
          final value = values[index];
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: value.abs(),
                color: isTouched
                    ? Colors
                          .yellow // Желтый при наведении
                    : (isNegative[index] ? Colors.red : Colors.green),
                width: 8, // Фиксированная ширина
                borderRadius: BorderRadius.zero,
              ),
            ],
          );
        }),
      ),
    );
  }
}
