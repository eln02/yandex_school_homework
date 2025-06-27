import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/app/theme/texts_extension.dart';
import 'package:yandex_school_homework/features/categories/domain/entity/category_entity.dart';
import 'package:yandex_school_homework/features/categories/domain/state/categories_cubit.dart';
import 'package:yandex_school_homework/features/categories/domain/state/categories_state.dart';
import 'package:yandex_school_homework/features/categories/presentation/components/categories_list.dart';
import 'package:yandex_school_homework/features/common/ui/app_error_screen.dart';
import 'package:yandex_school_homework/features/common/ui/custom_app_bar.dart';
import 'package:yandex_school_homework/features/common/ui/parametres_bar_wrapper.dart';
import 'package:yandex_school_homework/router/app_router.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CategoriesCubit(context.di.repositories.categoriesRepository),
      child: const _CategoriesScreenView(),
    );
  }
}

class _CategoriesScreenView extends StatefulWidget {
  const _CategoriesScreenView();

  @override
  State<_CategoriesScreenView> createState() => _CategoriesScreenViewState();
}

class _CategoriesScreenViewState extends State<_CategoriesScreenView> {
  @override
  void initState() {
    super.initState();
    context.read<CategoriesCubit>().fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        return switch (state) {
          CategoriesLoadingState() => const Center(
            child: CircularProgressIndicator(),
          ),
          CategoriesErrorState() => AppErrorScreen(
            errorMessage: state.errorMessage,
            onError: () => context.read<CategoriesCubit>().fetchCategories(),
          ),
          CategoriesLoadedState() => _CategoriesSuccessScreen(
            categories: state.categories,
          ),
        };
      },
    );
  }
}

class _CategoriesSuccessScreen extends StatelessWidget {
  const _CategoriesSuccessScreen({required this.categories});

  final List<CategoryEntity> categories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        extraHeight: 56,
        title: 'Мои статьи',
        children: [
          ParametersBarWrapper(
            color: context.colors.surfaceContainer,
            onTap: () => context.pushNamed(AppRouter.searchCategories),
            children: [
              Text('Найти статью', style: context.texts.bodyLarge_),
              const Icon(Icons.search),
            ],
          ),
        ],
      ),
      body: CategoriesList(
        categories: categories,
        onRefresh: () => context.read<CategoriesCubit>().fetchCategories(),
      ),
    );
  }
}
