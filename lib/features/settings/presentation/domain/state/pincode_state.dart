import 'package:equatable/equatable.dart';

sealed class PinCodeState extends Equatable {
  const PinCodeState();

  @override
  List<Object?> get props => [];
}

class PinInitial extends PinCodeState {}

class PinLoading extends PinCodeState {}

class PinNotSet extends PinCodeState {}

class PinSet extends PinCodeState {}

class PinValidated extends PinCodeState {}

class PinValidationFailed extends PinCodeState {}

final class PinConfirmed extends PinCodeState {}

//class PinUpdated extends PinCodeState {}

class PinDeleted extends PinCodeState {}

class PinError extends PinCodeState {
  final String message;

  const PinError(this.message);

  @override
  List<Object?> get props => [message];
}
