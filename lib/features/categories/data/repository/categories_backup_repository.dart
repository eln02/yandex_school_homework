import 'package:yandex_school_homework/app/http/i_http_client.dart';
import 'package:yandex_school_homework/app/database/i_database_service.dart';
import 'package:yandex_school_homework/features/categories/domain/repository/i_categories_repository.dart';
import 'package:yandex_school_homework/features/categories/data/dto/category_dto.dart';
import 'package:yandex_school_homework/features/categories/data/dto/category_dto_mapper.dart';
import 'package:yandex_school_homework/features/categories/domain/entity/category_entity.dart';

final class CategoriesBackupRepository implements ICategoriesRepository {
  CategoriesBackupRepository({
    required this.httpClient,
    required this.databaseService,
  });

  final IHttpClient httpClient;
  final IDatabaseService databaseService;

  @override
  String get name => 'CategoriesBackupRepository';

  static const String categoriesEndpoint = 'categories';

  @override
  Future<List<CategoryEntity>> fetchCategories() async {
    try {
      // 2. Загружаем актуальные данные с сервера
      final remoteCategories = await _fetchFromApi();

      // 3. Сохраняем в локальную базу
      await databaseService.saveCategories(remoteCategories);

      return remoteCategories;
    } catch (e) {
      // Если API недоступно, используем локальные данные
      return await databaseService.getAllCategories();
    }
  }

  Future<List<CategoryEntity>> _fetchFromApi() async {
    final response = await httpClient.get(categoriesEndpoint);
    final data = response.data as List<dynamic>;
    return data.map((e) => CategoryDto.fromJson(e).toEntity()).toList();
  }
}
