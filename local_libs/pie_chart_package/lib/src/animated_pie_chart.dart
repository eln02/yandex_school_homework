import 'dart:math';
import 'package:flutter/material.dart';
import 'models/pie_chart_data_model.dart';
import 'pie_chart_sample.dart';

class AnimatedPieChart extends StatefulWidget {
  final List<PieChartDataModel> oldData;
  final List<PieChartDataModel> newData;
  final bool animate;
  final List<Color> sectionColors;
  final double? _diagramContainerSize;

  const AnimatedPieChart({
    super.key,
    required this.oldData,
    required this.newData,
    required this.animate,
    this.sectionColors = PieChartSample.defaultColors,
    double? diagramContainerSize,
  }) : _diagramContainerSize = diagramContainerSize;

  /// Фабричный конструктор для состояния загрузки
  factory AnimatedPieChart.loading({required double diagramContainerSize}) {
    return AnimatedPieChart(
      oldData: const [],
      newData: const [],
      animate: false,
      diagramContainerSize: diagramContainerSize,
    );
  }

  bool get _isLoading => _diagramContainerSize != null;

  @override
  State<AnimatedPieChart> createState() => _AnimatedPieChartState();
}

class _AnimatedPieChartState extends State<AnimatedPieChart>
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
  void didUpdateWidget(AnimatedPieChart oldWidget) {
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

  Widget _buildChart(List<PieChartDataModel> categories, double opacity) {
    return Opacity(
      opacity: opacity,
      child: PieChartSample(
        categories: categories,
        sectionColors: widget.sectionColors,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget._isLoading) {
      return AspectRatio(
        aspectRatio: 1,
        child: Container(
          height: widget._diagramContainerSize,
          padding: const EdgeInsets.all(4),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox.expand(
                child: CircularProgressIndicator(
                  strokeWidth: 8,
                  color: Colors.grey[300],
                ),
              ),
              const Text('Загрузка графика'),
            ],
          ),
        ),
      );
    }

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
