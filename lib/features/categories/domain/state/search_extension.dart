import 'package:fuzzy/fuzzy.dart';
import 'package:yandex_school_homework/features/categories/domain/entity/category_entity.dart';
import 'package:yandex_school_homework/features/categories/domain/state/categories_state.dart';

/// Расширение для получения отфильтрованных категорий с fuzzy-поиском
extension CategoriesSearchExt on CategoriesLoadedState {
  List<CategoryEntity> filteredCategories(String query) {
    if (query.isEmpty) return categories;

    final names = categories.map((c) => c.name).toList();
    final fuse = Fuzzy(names);
    final results = fuse.search(query);

    return results
        .map((r) => categories.firstWhere((c) => c.name == r.item))
        .toList();
  }
}
