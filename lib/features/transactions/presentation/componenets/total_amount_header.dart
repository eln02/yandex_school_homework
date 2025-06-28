import 'package:flutter/material.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/app/theme/texts_extension.dart';
import 'package:yandex_school_homework/features/common/ui/parametres_bar_wrapper.dart';

/// Раздел для отображения суммы
class TotalAmountBar extends StatelessWidget {
  const TotalAmountBar({
    super.key,
    required this.totalAmount,
    required this.currency,
    required this.title,
    this.color,
    this.isLast = true,
  });

  final String totalAmount;
  final String currency;
  final String title;
  final Color? color;
  final bool isLast;

  double get height => 56.0;

  @override
  Widget build(BuildContext context) {
    return ParametersBarWrapper(
      color: color,
      isLast: isLast,
      children: [
        Text(title, style: context.texts.bodyLarge_),
        Text('$totalAmount $currency', style: context.texts.bodyLarge_),
      ],
    );
  }
}
