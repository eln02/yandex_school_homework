import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/app/theme/app_colors_scheme.dart';
import 'package:yandex_school_homework/app/theme/texts_extension.dart';
import 'package:yandex_school_homework/features/common/ui/parametres_bar_wrapper.dart';

/// Раздел для выбора дат
class DateFilterBar extends StatelessWidget {
  const DateFilterBar({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onDatesChanged,
    this.color,
    this.wrapData = false,
  });

  final DateTime startDate;
  final DateTime endDate;
  final void Function(DateTime? start, DateTime? end) onDatesChanged;
  final Color? color;
  final bool wrapData;

  double get height => 112.0;

  Future<void> _pickDate(
    BuildContext context,
    DateTime initialDate,
    bool isStartDate,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().toUtc(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: context.colors.financeGreen,
              surface: context.colors.mainBackground,
              onSurface: context.colors.onSurface_,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDatesChanged(isStartDate ? picked : null, !isStartDate ? picked : null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DateTile(
          label: 'Начало',
          date: startDate,
          onTap: () => _pickDate(context, startDate, true),
          color: color,
          wrapDate: wrapData,
        ),
        _DateTile(
          label: 'Конец',
          date: endDate,
          onTap: () => _pickDate(context, endDate, false),
          color: color,
          wrapDate: wrapData,
        ),
      ],
    );
  }
}

class _DateTile extends StatelessWidget {
  const _DateTile({
    required this.label,
    required this.date,
    required this.onTap,
    this.color,
    this.wrapDate = false,
  });

  final String label;
  final DateTime date;
  final VoidCallback onTap;
  final Color? color;
  final bool wrapDate;

  @override
  Widget build(BuildContext context) {
    final formatted = DateFormat('dd.MM.yyyy').format(date);

    final dateText = Text(
      formatted,
      style: context.texts.bodyLarge_.copyWith(
        color: wrapDate
            ? context.colors.onColoredBackground_
            : context.colors.onSurface_,
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: ParametersBarWrapper(
        color: color,
        children: [
          Text(label, style: context.texts.bodyLarge_),
          wrapDate
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.financeGreen,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: dateText,
                )
              : dateText,
        ],
      ),
    );
  }
}
