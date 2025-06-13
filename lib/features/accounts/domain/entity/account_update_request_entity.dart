import 'package:equatable/equatable.dart';

class AccountUpdateRequestEntity with EquatableMixin {
  final String name;
  final String balance;
  final String currency;

  const AccountUpdateRequestEntity({
    required this.name,
    required this.balance,
    required this.currency,
  });

  @override
  List<Object?> get props => [name, balance, currency];
}
