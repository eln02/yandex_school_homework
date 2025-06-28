import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:yandex_school_homework/features/categories/domain/entity/category_entity.dart';

/// Состояние для работы с категориями
@immutable
sealed class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object?> get props => [];
}

/// Состояние загрузки категорий
final class CategoriesLoadingState extends CategoriesState {
  const CategoriesLoadingState();
}

final class CategoriesLoadedState extends CategoriesState {
  const CategoriesLoadedState({required this.categories});

  /// Категории
  final List<CategoryEntity> categories;

  @override
  List<Object?> get props => [categories];
}

/// Состояние ошибки загрузки категорий
final class CategoriesErrorState extends CategoriesState {
  const CategoriesErrorState(this.stackTrace, {required this.errorMessage});

  final String errorMessage;
  final StackTrace? stackTrace;

  @override
  List<Object?> get props => [errorMessage, stackTrace];
}
