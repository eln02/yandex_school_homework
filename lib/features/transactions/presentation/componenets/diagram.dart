import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/category_analysis_entity.dart';

class PieChartSample extends StatelessWidget {
  final List<CategoryAnalysisEntity> categories;

  const PieChartSample({
    super.key,
    required this.categories,
  });

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
                    style: TextStyle(
                      fontSize: 10,
                      color: context.colors.onSurface,
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  final List<Color> sectionColors = const [
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
  final bool animate;

  const AnimatedPieChartSwitcher({
    super.key,
    required this.oldData,
    required this.newData,
    required this.animate,
  });

  @override
  State<AnimatedPieChartSwitcher> createState() =>
      _AnimatedPieChartSwitcherState();
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
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _rotation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    if (widget.animate) {
      _controller.forward();
    }

    _controller.addListener(() {
      if (_controller.value >= 0.5 && _showOld) {
        setState(() => _showOld = false);
      }
    });
  }

  @override
  void didUpdateWidget(AnimatedPieChartSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      _showOld = true;
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildChart(List<CategoryAnalysisEntity> categories, double opacity) {
    return Opacity(
      opacity: opacity,
      child: PieChartSample(
        categories: categories,
      ),
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
              if (_showOld && widget.oldData.isNotEmpty)
                _buildChart(widget.oldData, _fadeOut.value),
              if (!_showOld || widget.oldData.isEmpty || !widget.animate)
                _buildChart(
                  widget.newData,
                  widget.animate ? _fadeIn.value : 1.0,
                ),
            ],
          ),
        );
      },
    );
  }
}
