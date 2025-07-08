import 'package:yandex_school_homework/app/database/i_database_service.dart';
import 'package:yandex_school_homework/features/categories/domain/entity/category_entity.dart';
import 'package:yandex_school_homework/features/categories/domain/repository/i_categories_repository.dart';

final class CategoriesLocalRepository implements ICategoriesRepository {
  CategoriesLocalRepository({required this.databaseService});

  final IDatabaseService databaseService;

  @override
  String get name => 'CategoriesLocalRepository';

  @override
  Future<List<CategoryEntity>> fetchCategories() async {
    return await databaseService.getAllCategories();
  }

  @override
  Future<List<CategoryEntity>> fetchCategoriesByType(bool isIncome) {
    // TODO: implement fetchCategoriesByType
    throw UnimplementedError();
  }
}