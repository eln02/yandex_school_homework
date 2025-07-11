import 'package:equatable/equatable.dart';

class AccountEntity with EquatableMixin {
  final int id;
  final int userId;
  final String name;
  final String balance;
  final String currency;
  final DateTime createdAt;
  final DateTime updatedAt;

  AccountEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.balance,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
  });

  AccountEntity copyWith({
    int? id,
    int? userId,
    String? name,
    String? balance,
    String? currency,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AccountEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object> get props => [
    id,
    userId,
    name,
    balance,
    currency,
    createdAt,
    updatedAt,
  ];
}
