import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// ChangeNotifier для работы с диапазоном дат
class DateRangeNotifier extends ChangeNotifier {
  DateTime _startDate;
  DateTime _endDate;

  /// Основной конструктор
  DateRangeNotifier({required startDate, required DateTime endDate})
    : _startDate = startDate,
      _endDate = endDate;

  /// Фабричный конструктор для последнего месяца
  factory DateRangeNotifier.lastMonth() {
    final now = DateTime.now().toUtc();
    final lastMonth = DateTime(now.year, now.month - 1, now.day);
    return DateRangeNotifier(startDate: lastMonth, endDate: now);
  }

  /// Конструктор из строковых значений
  factory DateRangeNotifier.fromStrings({
    required String startDate,
    required String endDate,
  }) {
    final formatter = DateFormat('dd.MM.yyyy');
    return DateRangeNotifier(
      startDate: formatter.parse(startDate),
      endDate: formatter.parse(endDate),
    );
  }

  /// Геттеры для доступа к датам
  DateTime get startDate => _startDate;

  DateTime get endDate => _endDate;

  /// Геттеры в формате 'yyyy-MM-dd' для api
  String get apiFormattedStartDate => _formatForApi(_startDate);

  String get apiFormattedEndDate => _formatForApi(_endDate);

  /// Геттеры в формате 'dd.MM.yyyy' для ui
  String get uiFormattedStartDate => _formatForUi(_startDate);

  String get uiFormattedEndDate => _formatForUi(_endDate);

  /// Обновление диапазона дат с авто-коррекцией
  void updateDateRange({DateTime? startDate, DateTime? endDate}) {
    var newStart = startDate ?? _startDate;
    var newEnd = endDate ?? _endDate;

    /// Если начало позже конца — выравниваем диапазон по изменённой дате и наоборот
    if (newStart.isAfter(newEnd)) {
      if (startDate != null) {
        newEnd = newStart;
      } else {
        newStart = newEnd;
      }
    }

    _startDate = newStart;
    _endDate = newEnd;
    notifyListeners();
  }

  /// Приватные методы форматирования
  String _formatForApi(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  String _formatForUi(DateTime date) => DateFormat('dd.MM.yyyy').format(date);
}
