import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_school_homework/features/settings/presentation/domain/state/biometric_auth/biometric_auth_cubit.dart';
import 'package:yandex_school_homework/features/settings/presentation/domain/state/biometric_auth/biometric_auth_state.dart';
import 'package:yandex_school_homework/features/settings/presentation/domain/state/biometric_auth/biometric_status_notifier.dart';
import 'package:yandex_school_homework/features/settings/presentation/domain/state/pin_status_notifier.dart';
import 'package:yandex_school_homework/features/settings/presentation/domain/state/pincode_cubit.dart';
import 'package:yandex_school_homework/features/settings/presentation/domain/state/pincode_state.dart';
import 'package:yandex_school_homework/router/app_router.dart';

enum PinActionType { set, update, delete, confirm }

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
  void dispose() {
    _pinController.dispose();
    _newPinController.dispose();
    super.dispose();
  }

  void _onConfirmPressed(BuildContext context) {
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

  void _handleBiometricSuccess(BuildContext context) {
    if (context.read<BiometricAuthCubit>().state is BiometricSuccess) {
      context.read<PinStatusNotifier>().setPinStatus(true);
      context.read<PinOperationCubit>().confirmWithoutPin(); // ✅ правильно
      context.go(AppRouter.initialLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_getTitle(widget.actionType))),
      body: BlocConsumer<PinOperationCubit, PinOperationState>(
        listener: (context, state) {
          switch (state) {
            case PinSetSuccess():
              context.read<PinStatusNotifier>().setPinStatus(true);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Пин установлен')));
              context.pop();
              break;
            case PinUpdated():
              context.read<PinStatusNotifier>().setPinStatus(true);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Пин обновлен')));
              context.pop();
              break;
            case PinConfirmed():
              context.read<PinStatusNotifier>().setPinStatus(true);
              context.go(AppRouter.initialLocation);
              break;
            case PinDeleted():
              context.read<PinStatusNotifier>().setPinStatus(false);
              context.read<BiometricStatusNotifier>().setBiometricEnabled(
                false,
              );
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Пин удален')));
              context.pop();
              break;
            case PinError(:final message):
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
              break;
            case PinValidationFailed():
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Неверный PIN')));
              break;
            default:
              break;
          }
        },
        builder: (context, state) {
          final isLoading = state is PinLoading;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (isUpdate || isDelete || isConfirm)
                          _buildPinField('Текущий PIN', _pinController),
                        if (isSet || isUpdate)
                          _buildPinField(
                            'Новый PIN',
                            isSet ? _pinController : _newPinController,
                          ),
                      ],
                    ),
                  ),
                ),
                if (isConfirm) _buildBiometricSection(context),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () => _onConfirmPressed(context),
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
        },
      ),
    );
  }

  Widget _buildPinField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      maxLength: 4,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      validator: _pinValidator,
    );
  }

  Widget _buildBiometricSection(BuildContext context) {
    final biometricNotifier = context.watch<BiometricStatusNotifier>();
    final isBiometricEnabled = biometricNotifier.value;

    if (!isBiometricEnabled) {
      return const SizedBox.shrink(); // Не показываем кнопку
    }

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
                  : () async {
                      // Дополнительная проверка, чтобы точно не запускать биометрию при выключенном флаге
                      if (!biometricNotifier.value) return;

                      await context.read<BiometricAuthCubit>().authenticate();

                      if (context.read<BiometricAuthCubit>().state
                          is BiometricSuccess) {
                        _handleBiometricSuccess(context);
                      }
                    },
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
  }

  String _getTitle(PinActionType type) {
    return switch (type) {
      PinActionType.set => 'Установить PIN',
      PinActionType.update => 'Сменить PIN',
      PinActionType.delete => 'Удалить PIN',
      PinActionType.confirm => 'Введите PIN',
    };
  }

  String? _pinValidator(String? value) {
    if (value == null || value.length != 4) return 'Введите 4 цифры';
    if (!RegExp(r'^\d{4}$').hasMatch(value)) return 'Только цифры';
    return null;
  }
}
