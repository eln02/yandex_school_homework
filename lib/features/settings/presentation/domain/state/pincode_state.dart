import 'package:equatable/equatable.dart';

sealed class PinOperationState extends Equatable {
  const PinOperationState();

  @override
  List<Object?> get props => [];
}

class PinOperationInitial extends PinOperationState {}

class PinLoading extends PinOperationState {}

class PinSetSuccess extends PinOperationState {}

class PinConfirmed extends PinOperationState {}

class PinDeleted extends PinOperationState {}

class PinUpdated extends PinOperationState {}

class PinValidationFailed extends PinOperationState {}

class PinError extends PinOperationState {
  final String message;

  const PinError(this.message);

  @override
  List<Object?> get props => [message];
}
