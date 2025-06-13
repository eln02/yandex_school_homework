import 'package:yandex_school_homework/app/http/i_http_client.dart';
import 'package:yandex_school_homework/features/categories/data/dto/category_dto.dart';
import 'package:yandex_school_homework/features/categories/data/dto/category_dto_mapper.dart';
import 'package:yandex_school_homework/features/categories/domain/entity/category_entity.dart';
import 'package:yandex_school_homework/features/categories/domain/repository/i_categories_repository.dart';


final class CategoriesRepository implements ICategoriesRepository {
  CategoriesRepository({required this.httpClient});

  final IHttpClient httpClient;

  @override
  String get name => 'CategoriesRepository';

  static const String categories = 'categories';

  @override
  Future<List<CategoryEntity>> fetchCategories() async {
    final response = await httpClient.get(categories);

    final List<dynamic> data = response.data;
    return (data).map((item) => CategoryDto.fromJson(item).toEntity()).toList();
  }

  @override
  Future<List<CategoryEntity>> fetchCategoriesByType(bool isIncome) async {
    final response = await httpClient.get('$categories/type/$isIncome');

    final List<dynamic> data = response.data;
    return (data).map((item) => CategoryDto.fromJson(item).toEntity()).toList();
  }
}
