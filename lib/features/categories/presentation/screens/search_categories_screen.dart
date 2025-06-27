import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/app/theme/app_colors_scheme.dart';
import 'package:yandex_school_homework/app/theme/texts_extension.dart';
import 'package:yandex_school_homework/features/categories/domain/state/categories_cubit.dart';
import 'package:yandex_school_homework/features/categories/domain/state/categories_state.dart';
import 'package:yandex_school_homework/features/categories/domain/state/search_extension.dart';
import 'package:yandex_school_homework/features/categories/presentation/components/categories_list.dart';
import 'package:yandex_school_homework/features/common/ui/app_error_screen.dart';

/// Экран поиска категорий
class SearchCategoriesScreen extends StatelessWidget {
  const SearchCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CategoriesCubit(context.di.repositories.categoriesRepository)
            ..fetchCategories(),
      child: _SearchCategoriesView(),
    );
  }
}

class _SearchCategoriesView extends StatelessWidget {
  _SearchCategoriesView();

  /// ValueNotifier для поискового запроса
  final ValueNotifier<String> queryNotifier = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          style: context.texts.bodyLarge_.copyWith(
            color: context.colors.onSurfaceText,
          ),
          onChanged: (value) => queryNotifier.value = value,
          decoration: InputDecoration(
            hintText: 'Найти категорию...',
            hintStyle: context.texts.bodyLarge_,
            border: InputBorder.none,
          ),
        ),
      ),
      body: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          return switch (state) {
            CategoriesLoadingState() => const Center(
              child: CircularProgressIndicator(),
            ),
            CategoriesErrorState() => AppErrorScreen(
              errorMessage: state.errorMessage,
              onError: () => context.read<CategoriesCubit>().fetchCategories(),
            ),
            CategoriesLoadedState() => ValueListenableBuilder<String>(
              valueListenable: queryNotifier,
              builder: (context, query, _) {
                return CategoriesList(
                  categories: state.filteredCategories(query),
                  onRefresh: () =>
                      context.read<CategoriesCubit>().fetchCategories(),
                );
              },
            ),
          };
        },
      ),
    );
  }
}
