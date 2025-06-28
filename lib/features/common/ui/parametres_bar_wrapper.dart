import 'package:flutter/material.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/app/theme/app_colors_scheme.dart';

/// Виджет-обертка для одинакового стиля всех разделов
class ParametersBarWrapper extends StatelessWidget {
  const ParametersBarWrapper({
    super.key,
    required this.children,
    this.isLast = false,
    this.onTap,
    this.color,
  });

  final List<Widget> children;
  final bool isLast;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: color ?? context.colors.lightFinanceGreen,
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color: context.colors.transactionsDivider,
                    width: 1,
                  ),
                ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ),
    );
  }
}
