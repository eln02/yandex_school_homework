import 'package:equatable/equatable.dart';

class CategoryEntity with EquatableMixin {
  const CategoryEntity({
    required this.id,
    required this.name,
    required this.emoji,
    required this.isIncome,
  });

  final int id;
  final String name;
  final String emoji;
  final bool isIncome;

  @override
  List<Object> get props => [id, name, emoji, isIncome];
}
