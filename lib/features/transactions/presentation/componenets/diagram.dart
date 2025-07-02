import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/category_analysis_entity.dart';

class PieChartSample extends StatelessWidget {
  final List<CategoryAnalysisEntity> categories;


  @override
  Widget build(BuildContext context) {
    final chart = PieChart(
      PieChartData(
        sectionsSpace: 0,
        centerSpaceRadius:
        (130 - 8) / 2 * MediaQuery.of(context).size.width / 412,
        sections: _buildSections(),
      ),
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        chart,
        // 👇 Центр круга — сюда можно что угодно
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Всего',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 4),
            Text(
              '12 000 ₽',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  final List<Color> sectionColors = const [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.brown,
    Colors.indigo,
    Colors.cyan,
  ];

  const PieChartSample({super.key, required this.categories});

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



class AnimatedPieChartSwitcher extends StatefulWidget {
  final List<CategoryAnalysisEntity> oldData;
  final List<CategoryAnalysisEntity> newData;

  const AnimatedPieChartSwitcher({
    super.key,
    required this.oldData,
    required this.newData,
  });

  @override
  State<AnimatedPieChartSwitcher> createState() => _AnimatedPieChartSwitcherState();
}

class _AnimatedPieChartSwitcherState extends State<AnimatedPieChartSwitcher>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotation;
  late final Animation<double> _fadeOut;
  late final Animation<double> _fadeIn;

  bool _showOld = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _rotation = Tween<double>(begin: 0, end: 2 * pi).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
    ));

    _controller.addListener(() {
      if (_controller.value >= 0.5 && _showOld) {
        setState(() {
          _showOld = false; // На 180° — переключаем контент
        });
      }
    });

    _controller.forward(); // Запускаем анимацию сразу
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildChart(List<CategoryAnalysisEntity> categories, double opacity) {
    return Opacity(
      opacity: opacity,
      child: PieChartSample(categories: categories),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.rotate(
          angle: _rotation.value,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (_showOld)
                _buildChart(widget.oldData, _fadeOut.value)
              else
                _buildChart(widget.newData, _fadeIn.value),
            ],
          ),
        );
      },
    );
  }
}
