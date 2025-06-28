import 'package:flutter/material.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/app/theme/app_colors_scheme.dart';
import 'package:yandex_school_homework/app/theme/texts_extension.dart';
import 'package:yandex_school_homework/features/categories/domain/entity/category_entity.dart';

/// Виджет списка категорий
class CategoriesList extends StatelessWidget {
  const CategoriesList({
    super.key,
    required this.categories,
    required this.onRefresh,
  });

  final List<CategoryEntity> categories;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        itemCount: categories.length + 1,
        separatorBuilder: (_, __) =>
            Divider(height: 1, color: context.colors.transactionsDivider),
        itemBuilder: (context, index) {
          // добавление Divider под последним элементом
          if (index == categories.length) {
            return const SizedBox.shrink();
          }
          return _CategoryTile(category: categories[index]);
        },
      ),
    );
  }
}

/// Тайл категории
class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category});

  final CategoryEntity category;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(category.emoji, style: context.texts.emoji),
          const SizedBox(width: 16),
          Text(category.name, style: context.texts.bodyLarge_),
        ],
      ),
    );
  }
}
