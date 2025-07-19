import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_school_homework/features/settings/presentation/data/pincode_service/i_auth_service.dart';
import 'package:yandex_school_homework/features/settings/presentation/domain/state/pin_operation_state.dart';

class PinOperationCubit extends Cubit<PinOperationState> {
  final IAuthService _pinService;

  PinOperationCubit(this._pinService) : super(PinOperationInitial());

  Future<void> savePin(String pin) async {
    emit(PinLoading());
    try {
      await _pinService.savePin(pin);
      emit(PinSetSuccess());
    } catch (e) {
      emit(const PinError('Ошибка при установке PIN'));
    }
  }

  Future<void> validatePin(String pin) async {
    emit(PinLoading());
    try {
      final isValid = await _pinService.validatePin(pin);
      if (isValid) {
        emit(PinConfirmed());
      } else {
        emit(PinValidationFailed());
      }
    } catch (e) {
      emit(const PinError('Ошибка при проверке PIN'));
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

  Future<void> updatePin(String oldPin, String newPin) async {
    emit(PinLoading());
    try {
      final isValid = await _pinService.validatePin(oldPin);

      if (!isValid) {
        emit(PinValidationFailed());
        return;
      }
      await _pinService.updatePin(oldPin, newPin);

      emit(PinUpdated());
    } catch (e) {
      emit(const PinError('Ошибка при обновлении PIN'));
    }
  }

  void confirmWithoutPin() {
    emit(PinConfirmed());
  }
}
