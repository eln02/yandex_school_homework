import 'package:equatable/equatable.dart';

class CategoryAnalysisEntity extends Equatable {
  final String name;
  final String emoji;
  final String? lastComment;
  final double percent;
  final double amount;

  const CategoryAnalysisEntity({
    required this.name,
    required this.emoji,
    required this.percent,
    required this.amount,
    this.lastComment,
  });

  @override
  List<Object?> get props => [name, emoji, percent, amount, lastComment];
}
