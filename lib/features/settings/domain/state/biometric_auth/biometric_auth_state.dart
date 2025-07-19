import 'package:equatable/equatable.dart';

sealed class BiometricAuthState extends Equatable {
  const BiometricAuthState();

  @override
  List<Object?> get props => [];
}

class BiometricInitial extends BiometricAuthState {}

class BiometricChecking extends BiometricAuthState {}

class BiometricAvailable extends BiometricAuthState {}

class BiometricUnavailable extends BiometricAuthState {
  final String reason;

  const BiometricUnavailable(this.reason);

  @override
  List<Object?> get props => [reason];
}

class BiometricAuthenticating extends BiometricAuthState {}

class BiometricSuccess extends BiometricAuthState {}

class BiometricFailure extends BiometricAuthState {
  final String reason;

  const BiometricFailure(this.reason);

  @override
  List<Object?> get props => [reason];
}

class BiometricError extends BiometricAuthState {
  final String message;

  const BiometricError(this.message);

  @override
  List<Object?> get props => [message];
}
