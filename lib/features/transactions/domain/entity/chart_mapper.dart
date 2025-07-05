import 'package:yandex_school_homework/features/transactions/domain/entity/category_analysis_entity.dart';
import 'package:pie_chart_package/pie_chart_package.dart';

extension CategoryPieMapper on List<CategoryAnalysisEntity> {
  /// Конвертирует список CategoryAnalysisEntity в список PieChartDataModel
  /// для использования в графике PieChart
  List<PieChartDataModel> toPieChartData() {
    return map(
      (category) => PieChartDataModel(
        id: category.id.toString(),
        name: category.name,
        percent: category.percent,
      ),
    ).toList();
  }
}
