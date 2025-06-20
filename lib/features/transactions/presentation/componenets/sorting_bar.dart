import 'package:flutter/material.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/app/theme/app_colors_scheme.dart';
import 'package:yandex_school_homework/app/theme/texts_extension.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/sorting_enum.dart';
import 'package:yandex_school_homework/features/transactions/presentation/componenets/parametres_bar_wrapper.dart';

/// Раздел для выбора типа сортировки
class SortingBar extends StatelessWidget {
  final SortingType currentSorting;
  final ValueChanged<SortingType> onSortingChanged;

  const SortingBar({
    super.key,
    required this.currentSorting,
    required this.onSortingChanged,
  });

  double get height => 56.0;

  @override
  Widget build(BuildContext context) {
    return ParametersBarWrapper(
      children: [
        Text('Сортировка', style: context.texts.bodyLarge_),
        Transform.translate(
          offset: const Offset(8, 0),
          child: DropdownButton<SortingType>(
            alignment: Alignment.centerRight,
            value: currentSorting,
            underline: const SizedBox(),
            items: SortingType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(
                  type.displayName,
                  style: context.texts.bodyLarge_.copyWith(
                    color: context.colors.onSurfaceText,
                  ),
                ),
              );
            }).toList(),
            onChanged: (type) {
              if (type != null) {
                onSortingChanged(type);
              }
            },
          ),
        ),
      ],
    );
  }
}
