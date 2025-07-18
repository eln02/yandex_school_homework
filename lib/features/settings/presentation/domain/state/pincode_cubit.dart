import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_school_homework/features/settings/presentation/data/pincode_service/pincode_service.dart';
import 'package:yandex_school_homework/features/settings/presentation/domain/state/pincode_state.dart';

class PinCodeCubit extends Cubit<PinCodeState> {
  final IPinCodeService _pinService;

  PinCodeCubit(this._pinService) : super(PinInitial()) {
    _checkInitialPinState();
  }

  void _checkInitialPinState() {
    emit(_pinService.isPinSet ? PinSet() : PinNotSet());
  }

  Future<void> savePin(String pin) async {
    emit(PinLoading());
    try {
      await _pinService.savePin(pin);
      emit(PinSet());
    } catch (e) {
      emit(PinError(e.toString()));
      _checkInitialPinState();
    }
  }

  Future<void> updatePin(String oldPin, String newPin) async {
    emit(PinLoading());
    try {
      await _pinService.updatePin(oldPin, newPin);
      emit(PinSet());
    } catch (e) {
      emit(PinError(e.toString()));
      _checkInitialPinState();
    }
  }


  Future<void> validateAndDeletePin(String pin) async {
    emit(PinLoading());
    try {
      final isValid = await _pinService.validatePin(pin);
      if (isValid) {
        await _pinService.deletePin();
        emit(PinDeleted());
        emit(PinNotSet());
      } else {
        emit(PinValidationFailed());
      }
    } catch (e) {
      emit(PinError(e.toString()));
      _checkInitialPinState();
    }
  }

  Future<void> validatePin(String pin) async {
    emit(PinLoading());
    try {
      final isValid = await _pinService.validatePin(pin);
      if (isValid) {
        emit(PinConfirmed()); // для confirm
      } else {
        emit(PinValidationFailed());
      }
    } catch (e) {
      emit(PinError(e.toString()));
    }
  }
}
