import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_school_homework/features/settings/data/pincode_service/i_auth_service.dart';
import 'package:yandex_school_homework/features/settings/domain/state/pincode_auth/pin_operation_state.dart';

class PinOperationCubit extends Cubit<PinOperationState> {
  final IAuthService _pinService;

  PinOperationCubit(this._pinService) : super(PinOperationInitial());

  String? _validatedPin;

  Future<void> savePin(String pin) async {
    emit(PinLoading());
    try {
      await _pinService.savePin(pin);
      emit(PinSetSuccess());
    } catch (e) {
      emit(const PinError('Ошибка при установке PIN'));
    }
  }

  Future<void> validateAndDeletePin(String pin) async {
    emit(PinLoading());
    try {
      final isValid = await _pinService.validatePin(pin);
      if (!isValid) {
        emit(PinValidationFailed());
        return;
      }
      await _pinService.deletePin();

      emit(PinDeleted());
    } catch (e) {
      emit(const PinError('Ошибка при удалении PIN'));
    }
  }

  void confirmWithoutPin() {
    emit(PinConfirmed());
  }

  Future<void> validatePin(String pin) async {
    emit(PinLoading());
    try {
      final isValid = await _pinService.validatePin(pin);
      if (isValid) {
        _validatedPin = pin;
        emit(PinConfirmed());
      } else {
        emit(PinValidationFailed());
      }
    } catch (e) {
      emit(const PinError('Ошибка при проверке PIN'));
    }
  }

  Future<void> saveUpdatedPin(String newPin) async {
    emit(PinLoading());
    try {
      if (_validatedPin == null) {
        emit(const PinError('Старый PIN не подтвержден'));
        return;
      }

      await _pinService.updatePin(_validatedPin!, newPin);
      _validatedPin = null;
      emit(PinUpdated());
    } catch (e) {
      emit(const PinError('Ошибка при обновлении PIN'));
    }
  }
}
