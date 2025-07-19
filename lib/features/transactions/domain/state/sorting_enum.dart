import 'package:flutter/material.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';

/// Перечесление вариантов сортировок
enum SortingType {
  dateNewestFirst,
  dateOldestFirst,
  amountHighToLow,
  amountLowToHigh,
}

/// Расширение для получения названия каждого варианта сортировки
extension SortingTypeExtension on SortingType {
  String getDisplayName(BuildContext context) {
    return switch (this) {
      SortingType.dateNewestFirst => context.strings.sorting_date_newest,
      SortingType.dateOldestFirst => context.strings.sorting_date_oldest,
      SortingType.amountHighToLow => context.strings.sorting_amount_desc,
      SortingType.amountLowToHigh => context.strings.sorting_amount_asc,
    };
  }
}
