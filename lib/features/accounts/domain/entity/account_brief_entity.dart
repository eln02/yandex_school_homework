import 'package:equatable/equatable.dart';

class AccountBriefEntity with EquatableMixin {
  final int id;
  final String name;
  final String balance;
  final String currency;

  AccountBriefEntity({
    required this.id,
    required this.name,
    required this.balance,
    required this.currency,
  });

  @override
  List<Object> get props => [id, name, balance, currency];
}
