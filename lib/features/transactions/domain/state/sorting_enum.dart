/// Перечесление вариантов сортировок
enum SortingType {
  none,
  dateNewestFirst,
  dateOldestFirst,
  amountHighToLow,
  amountLowToHigh,
}

/// Расширение для получения названия каждого варианта сортировки
extension SortingTypeExtension on SortingType {
  String get displayName {
    return switch (this) {
      SortingType.dateNewestFirst => 'По дате (сначала новые)',
      SortingType.dateOldestFirst => 'По дате (сначала старые)',
      SortingType.amountHighToLow => 'По сумме (по убыванию)',
      SortingType.amountLowToHigh => 'По сумме (по возрастанию)',
      SortingType.none => 'Без сортировки',
    };
  }
}
