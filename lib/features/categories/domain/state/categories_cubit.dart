import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_school_homework/features/categories/domain/repository/i_categories_repository.dart';
import 'package:yandex_school_homework/features/categories/domain/state/categories_state.dart';

/// Кубит для работы с категориями
class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit(this.repository) : super(const CategoriesLoadingState());

  final ICategoriesRepository repository;

  /// Метод получения категорий
  Future<void> fetchCategories() async {
    emit(const CategoriesLoadingState());

    try {
      final categories = await repository.fetchCategories();

      emit(CategoriesLoadedState(categories: categories));
    } on Object catch (error, stackTrace) {
      emit(
        CategoriesErrorState(
          stackTrace,
          errorMessage: "Не удалось загрузить категории",
        ),
      );
    }
  }
}
