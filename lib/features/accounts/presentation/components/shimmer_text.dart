import 'package:flutter/material.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/app/theme/app_colors_scheme.dart';

/// Виджет шиммерного контейнера для скрытия баланса
class ShimmerText extends StatefulWidget {
  const ShimmerText({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor = Colors.white,
  });

  final Text child;
  final Color? baseColor;
  final Color highlightColor;

  @override
  State<ShimmerText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<ShimmerText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late double _textWidth;
  late double _textHeight;

  @override
  void initState() {
    super.initState();
    _calculateTextSize();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _controller.forward(from: 0);
            }
          })
          ..forward();
  }

  void _calculateTextSize() {
    final textPainter = TextPainter(
      text: TextSpan(text: widget.child.data, style: widget.child.style),
      maxLines: widget.child.maxLines,
      textDirection: TextDirection.ltr,
    )..layout();
    _textWidth = textPainter.width;
    _textHeight = textPainter.height;
  }

  @override
  void didUpdateWidget(ShimmerText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child.data != widget.child.data ||
        oldWidget.child.style != widget.child.style) {
      _calculateTextSize();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _textWidth,
      height: _textHeight + 6,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: widget.baseColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Positioned(
                left: _controller.value * (_textWidth + 40) - 40,
                child: Container(
                  width: 50,
                  height: _textHeight + 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.baseColor ?? context.colors.shimmerContainer,
                        widget.highlightColor.withAlpha((255 * 0.8).round()),
                        widget.baseColor ?? context.colors.shimmerContainer,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
