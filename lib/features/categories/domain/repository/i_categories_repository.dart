import 'package:yandex_school_homework/di/di_base_repo.dart';
import 'package:yandex_school_homework/features/categories/domain/entity/category_entity.dart';

abstract interface class ICategoriesRepository with DiBaseRepo {
  Future<List<CategoryEntity>> fetchCategories();
}
