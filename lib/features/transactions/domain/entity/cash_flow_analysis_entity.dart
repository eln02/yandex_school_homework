import 'package:equatable/equatable.dart';

/// Сущность данных анализа транзакций по дню
class CashFlowAnalysisEntity extends Equatable {
  final int id;

  /// Дата
  final DateTime date;

  /// Флоу (доходы минус расходы) за день
  final double flow;

  const CashFlowAnalysisEntity({
    required this.id,
    required this.date,
    required this.flow,
  });

  @override
  List<Object?> get props => [id, date, flow];
}
