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

  @override
  List<Object> get props => [id, userId, name, balance, currency, createdAt, updatedAt];
}
