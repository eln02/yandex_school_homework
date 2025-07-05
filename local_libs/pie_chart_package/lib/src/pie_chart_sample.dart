import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'models/pie_chart_data_model.dart';

class PieChartSample extends StatelessWidget {
  final List<PieChartDataModel> categories;
  final List<Color> sectionColors;

  const PieChartSample({
    super.key,
    required this.categories,
    this.sectionColors = defaultColors,
  });

  static const defaultColors = [
    Color(0xFF6582B3),
    Color(0xFF95F6B0),
    Color(0xFF95E2F5),
    Color(0xFFE4A3F8),
    Color(0xFFF8DB8D),
    Color(0xFFCDFA93),
    Color(0xFF949DF1),
    Color(0xFF6E99BC),
    Color(0xFFB0AAF5),
    Color(0xFFDDBBF6),
    Color(0xFFF5C39A),
    Color(0xFFFCF690),
    Color(0xFFE087A0),
  ];

  @override
  Widget build(BuildContext context) {
    final topCategories = categories.sublist(0)
      ..sort((a, b) => b.percent.compareTo(a.percent));
    final displayedCategories = topCategories.take(3).toList();

    final chart = PieChart(
      PieChartData(sectionsSpace: 0, sections: _buildSections()),
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        chart,
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...displayedCategories.map((category) {
              final originalIndex = categories.indexWhere(
                (c) => c.id == category.id,
              );
              final color = originalIndex != -1
                  ? sectionColors[originalIndex % sectionColors.length]
                  : Colors.grey;

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${category.percent.toStringAsFixed(1)}% ${category.name}',
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildSections() {
    return categories.asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value;
      final color = sectionColors[index % sectionColors.length];

      return PieChartSectionData(
        color: color,
        value: category.percent,
        radius: 8,
        title: '',
      );
    }).toList();
  }
}
