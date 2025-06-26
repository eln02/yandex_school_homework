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
  });

  final DateTime startDate;
  final DateTime endDate;
  final void Function(DateTime? start, DateTime? end) onDatesChanged;

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
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: context.colors.financeGreen,
              surface: context.colors.mainBackground,
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
        ),
        _DateTile(
          label: 'Конец',
          date: endDate,
          onTap: () => _pickDate(context, endDate, false),
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
  });

  final String label;
  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final formatted = DateFormat('dd.MM.yyyy').format(date);
    return GestureDetector(
      onTap: onTap,
      child: ParametersBarWrapper(
        children: [
          Text(label, style: context.texts.bodyLarge_),
          Text(formatted, style: context.texts.bodyLarge_),
        ],
      ),
    );
  }
}
