import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_school_homework/features/settings/presentation/domain/state/biometric_auth/biometric_auth_cubit.dart';
import 'package:yandex_school_homework/features/settings/presentation/domain/state/biometric_auth/biometric_auth_state.dart';
import 'package:yandex_school_homework/features/settings/presentation/domain/state/biometric_auth/biometric_status_notifier.dart';
import 'package:yandex_school_homework/features/settings/presentation/domain/state/pin_status_notifier.dart';
import 'package:yandex_school_homework/features/settings/presentation/domain/state/pin_operation_cubit.dart';
import 'package:yandex_school_homework/features/settings/presentation/domain/state/pin_operation_state.dart';
import 'package:yandex_school_homework/router/app_router.dart';

/// Типы операций с PIN-кодом
enum PinActionType { set, update, delete, confirm }

/// Экран для выполнения операций с PIN-кодом (установка, изменение, удаление, подтверждение)
class PinActionScreen extends StatefulWidget {
  final PinActionType actionType;

  const PinActionScreen({super.key, required this.actionType});

  @override
  State<PinActionScreen> createState() => _PinActionScreenState();
}

class _PinActionScreenState extends State<PinActionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pinController = TextEditingController();
  final _newPinController = TextEditingController();

  bool get isSet => widget.actionType == PinActionType.set;

  bool get isUpdate => widget.actionType == PinActionType.update;

  bool get isDelete => widget.actionType == PinActionType.delete;

  bool get isConfirm => widget.actionType == PinActionType.confirm;

  @override
  void initState() {
    super.initState();
    _initBiometric();
  }

  @override
  void dispose() {
    _pinController.dispose();
    _newPinController.dispose();
    super.dispose();
  }

  /// Инициализация биометрии (если включена)
  void _initBiometric() {
    final biometricNotifier = context.read<BiometricStatusNotifier>();
    if (biometricNotifier.value) {
      context.read<BiometricAuthCubit>().checkAvailability();
    }
  }

  /// Обработка нажатия кнопки подтверждения
  void _onConfirmPressed() {
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<PinOperationCubit>();

    switch (widget.actionType) {
      case PinActionType.set:
        cubit.savePin(_pinController.text);
        break;
      case PinActionType.update:
        cubit.updatePin(_pinController.text, _newPinController.text);
        break;
      case PinActionType.delete:
        cubit.validateAndDeletePin(_pinController.text);
        break;
      case PinActionType.confirm:
        cubit.validatePin(_pinController.text);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_getTitle(widget.actionType))),
      body: BlocConsumer<PinOperationCubit, PinOperationState>(
        listener: (context, state) => _handlePinOperationState(context, state),
        builder: (context, state) {
          return _PinActionContent(
            formKey: _formKey,
            actionType: widget.actionType,
            isLoading: state is PinLoading,
            pinController: _pinController,
            newPinController: _newPinController,
            onConfirmPressed: _onConfirmPressed,
          );
        },
      ),
    );
  }

  /// Обработка состояний операции с PIN-кодом
  void _handlePinOperationState(BuildContext context, PinOperationState state) {
    final pinNotifier = context.read<PinStatusNotifier>();
    final biometricNotifier = context.read<BiometricStatusNotifier>();

    switch (state) {
      case PinSetSuccess():
        pinNotifier.setPinStatus(true);
        _showSuccessSnackbar(context, 'Пин установлен');
        context.pop();
      case PinUpdated():
        pinNotifier.setPinStatus(true);
        _showSuccessSnackbar(context, 'Пин обновлен');
        context.pop();
      case PinConfirmed():
        pinNotifier.setPinStatus(true);
        context.go(AppRouter.initialLocation);
      case PinDeleted():
        pinNotifier.setPinStatus(false);
        biometricNotifier.setBiometricEnabled(false);
        _showSuccessSnackbar(context, 'Пин удален');
        context.pop();
      case PinError(:final message):
        _showErrorSnackbar(context, message);
      case PinValidationFailed():
        _showErrorSnackbar(context, 'Неверный PIN');
      default:
        break;
    }
  }

  /// Получение заголовка экрана в зависимости от типа операции
  String _getTitle(PinActionType type) {
    return switch (type) {
      PinActionType.set => 'Установить PIN',
      PinActionType.update => 'Сменить PIN',
      PinActionType.delete => 'Удалить PIN',
      PinActionType.confirm => 'Введите PIN',
    };
  }

  /// Показать уведомление об успехе
  void _showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Показать уведомление об ошибке
  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

/// Виджет с содержимым экрана операций с PIN-кодом
class _PinActionContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final PinActionType actionType;
  final bool isLoading;
  final TextEditingController pinController;
  final TextEditingController newPinController;
  final VoidCallback onConfirmPressed;

  const _PinActionContent({
    required this.formKey,
    required this.actionType,
    required this.isLoading,
    required this.pinController,
    required this.newPinController,
    required this.onConfirmPressed,
  });

  bool get isSet => actionType == PinActionType.set;

  bool get isUpdate => actionType == PinActionType.update;

  bool get isDelete => actionType == PinActionType.delete;

  bool get isConfirm => actionType == PinActionType.confirm;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  if (isUpdate || isDelete || isConfirm)
                    PinTextField(
                      label: 'Текущий PIN',
                      controller: pinController,
                    ),
                  if (isSet || isUpdate)
                    PinTextField(
                      label: 'Новый PIN',
                      controller: isSet ? pinController : newPinController,
                    ),
                ],
              ),
            ),
          ),
          if (isConfirm) const _BiometricAuthButton(),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: isLoading ? null : onConfirmPressed,
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Подтвердить'),
          ),
        ],
      ),
    );
  }
}

/// Поле ввода PIN-кода с валидацией
class PinTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const PinTextField({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      maxLength: 4,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      validator: _pinValidator,
    );
  }

  /// Валидация PIN-кода
  String? _pinValidator(String? value) {
    if (value == null || value.length != 4) return 'Введите 4 цифры';
    if (!RegExp(r'^\d{4}$').hasMatch(value)) return 'Только цифры';
    return null;
  }
}

/// Кнопка биометрической аутентификации
class _BiometricAuthButton extends StatelessWidget {
  const _BiometricAuthButton();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: context.read<BiometricStatusNotifier>(),
      builder: (context, isBiometricEnabled, _) {
        if (!isBiometricEnabled) return const SizedBox.shrink();

        return BlocBuilder<BiometricAuthCubit, BiometricAuthState>(
          builder: (context, state) {
            if (state is BiometricUnavailable || state is BiometricError) {
              return const SizedBox.shrink();
            }

            final isAuthenticating = state is BiometricAuthenticating;

            return Column(
              children: [
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: isAuthenticating
                      ? null
                      : () => _authenticateWithBiometrics(context),
                  icon: const Icon(Icons.fingerprint),
                  label: isAuthenticating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Войти по отпечатку'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Аутентификация с помощью биометрии
  Future<void> _authenticateWithBiometrics(BuildContext context) async {
    final biometricNotifier = context.read<BiometricStatusNotifier>();
    if (!biometricNotifier.value) return;

    final cubit = context.read<BiometricAuthCubit>();
    await cubit.authenticate();

    if (cubit.state is BiometricSuccess && context.mounted) {
      _handleBiometricSuccess(context);
    }
  }

  /// Обработка успешной биометрической аутентификации
  void _handleBiometricSuccess(BuildContext context) {
    context.read<PinStatusNotifier>().setPinStatus(true);
    context.read<PinOperationCubit>().confirmWithoutPin();
    context.go(AppRouter.initialLocation);
  }
}
