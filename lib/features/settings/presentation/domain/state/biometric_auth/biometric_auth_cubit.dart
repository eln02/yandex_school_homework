import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_school_homework/features/settings/presentation/data/biometrics_service/biometrics_service.dart';
import 'package:yandex_school_homework/features/settings/presentation/domain/state/biometric_auth/biometric_auth_state.dart';


class BiometricAuthCubit extends Cubit<BiometricAuthState> {
  final IBiometricAuthService _biometricService;

  BiometricAuthCubit(this._biometricService) : super(BiometricInitial());

  Future<void> checkAvailability() async {
    emit(BiometricChecking());

    try {
      if (_biometricService.isBiometricAvailable) {
        emit(BiometricAvailable());
      } else {
        emit(const BiometricUnavailable('Биометрия недоступна'));
      }
    } catch (e) {
      emit(BiometricError('Ошибка инициализации: $e'));
    }
  }

  Future<void> authenticate() async {
    emit(BiometricAuthenticating());

    try {
      final success = await _biometricService.authenticate(
        reason: 'Подтвердите личность с помощью биометрии',
      );

      if (success) {
        emit(BiometricSuccess());
      } else {
        emit(const BiometricFailure('Пользователь отменил вход или ошибка'));
      }
    } catch (e) {
      emit(BiometricError('Ошибка аутентификации: $e'));
    }
  }
}
