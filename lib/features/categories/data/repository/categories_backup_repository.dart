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
      // 1. Сначала пробуем синхронизировать неотправленные изменения
      await _syncPendingCategoryChanges();

      // 2. Затем загружаем актуальные данные с сервера
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

  Future<void> _syncPendingCategoryChanges() async {
    final operations = await databaseService.getUnsyncedOperations('category');
    if (operations.isEmpty) return;

    final successfulIds = <String>[];

    for (final op in operations) {
      try {
        switch (op.operationType) {
          case 'CREATE':
            await httpClient.post(categoriesEndpoint, data: op.payload);
            successfulIds.add(op.id);
            break;

          case 'UPDATE':
            await httpClient.put(
              '$categoriesEndpoint/${op.entityId}',
              data: op.payload,
            );
            successfulIds.add(op.id);
            break;

          case 'DELETE':
            await httpClient.delete('$categoriesEndpoint/${op.entityId}');
            successfulIds.add(op.id);
            break;
        }
      } catch (e) {
        // Прерываем синхронизацию при первой же ошибке
        break;
      }
    }

    if (successfulIds.isNotEmpty) {
      await databaseService.markAsSynced(successfulIds);
    }
  }
}
