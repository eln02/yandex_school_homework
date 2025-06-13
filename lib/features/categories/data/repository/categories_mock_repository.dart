import 'package:yandex_school_homework/features/categories/data/dto/category_dto.dart';
import 'package:yandex_school_homework/features/categories/data/dto/category_dto_mapper.dart';
import 'package:yandex_school_homework/features/categories/data/mock_data/categories_mock_data.dart';
import 'package:yandex_school_homework/features/categories/domain/entity/category_entity.dart';
import 'package:yandex_school_homework/features/categories/domain/repository/i_categories_repository.dart';

final class CategoriesMockRepository implements ICategoriesRepository {
  @override
  String get name => 'CategoriesMockRepository';

  @override
  Future<List<CategoryEntity>> fetchCategories() async {
    await Future.delayed(const Duration(seconds: 1));
    final List<dynamic> categories = CategoriesMockData.categories;

    return categories
        .map((json) => CategoryDto.fromJson(json).toEntity())
        .toList();
  }

  @override
  Future<List<CategoryEntity>> fetchCategoriesByType(bool isIncome) async {
    await Future.delayed(const Duration(seconds: 1));
    final List<dynamic> categories = CategoriesMockData.getCategoriesByIncome(
      isIncome,
    );

    return categories
        .map((json) => CategoryDto.fromJson(json).toEntity())
        .toList();
  }
}
