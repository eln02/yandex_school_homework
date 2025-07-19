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
    this.color,
    this.isLast = true,
  });

  /// конструктор для отображения раздела, пока сумма еще не загурзилась
  const TotalAmountBar.loading({
    super.key,
    this.color,
    this.isLast = true,
  }) : totalAmount = null,
       currency = null;

  final String? totalAmount;
  final String? currency;
  final Color? color;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return ParametersBarWrapper(
      color: color,
      isLast: isLast,
      children: [
        Text(context.strings.sum, style: context.texts.bodyLarge_),
        if (totalAmount != null && currency != null)
          Text('$totalAmount $currency', style: context.texts.bodyLarge_)
        else
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
      ],
    );
  }
}
