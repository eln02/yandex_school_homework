import 'package:yandex_school_homework/features/categories/data/dto/category_dto.dart';
import 'package:yandex_school_homework/features/categories/domain/entity/category_entity.dart';

extension CategoryDtoMapper on CategoryDto {
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      emoji: emoji,
      isIncome: isIncome,
    );
  }
}