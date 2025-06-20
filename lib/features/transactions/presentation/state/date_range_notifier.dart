import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// ChangeNotifier для работы с диапазоном дат
class DateRangeNotifier extends ChangeNotifier {
  DateTime _startDate;
  DateTime _endDate;

  /// Инициализация: последний месяц
  DateRangeNotifier()
    : _endDate = DateTime.now(),
      _startDate = DateTime(
        DateTime.now().year,
        DateTime.now().month - 1,
        DateTime.now().day,
      );

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
