import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/app/theme/app_colors_scheme.dart';
import 'package:yandex_school_homework/app/theme/texts_extension.dart';
import 'package:yandex_school_homework/features/common/ui/custom_app_bar.dart';
import 'package:yandex_school_homework/features/settings/domain/state/biometric_auth/biometric_auth_cubit.dart';
import 'package:yandex_school_homework/features/settings/domain/state/biometric_auth/biometric_auth_state.dart';
import 'package:yandex_school_homework/features/settings/domain/state/biometric_auth/biometric_status_notifier.dart';
import 'package:yandex_school_homework/features/settings/domain/state/pincode_auth/pin_operation_cubit.dart';
import 'package:yandex_school_homework/features/settings/domain/state/pincode_auth/pin_operation_state.dart';
import 'package:yandex_school_homework/features/settings/domain/state/pincode_auth/pin_status_notifier.dart';
import 'package:yandex_school_homework/router/app_router.dart';

/// Типы операций с PIN-кодом
enum PinActionType { set, update, delete, confirm }

/// Экран для выполнения операций с PIN-кодом
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

  void _initBiometric() {
    final biometricNotifier = context.read<BiometricStatusNotifier>();
    if (biometricNotifier.value) {
      context.read<BiometricAuthCubit>().checkAvailability();
    }
  }

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
      backgroundColor: context.colors.mainBackground,
      appBar: CustomAppBar(
        title: _getTitle(context, widget.actionType),
        showBackButton: true,
      ),
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

  void _handlePinOperationState(BuildContext context, PinOperationState state) {
    final pinNotifier = context.read<PinStatusNotifier>();
    final biometricNotifier = context.read<BiometricStatusNotifier>();

    switch (state) {
      case PinSetSuccess():
        pinNotifier.setPinStatus(true);
        _showSuccessSnackbar(context, context.strings.pinSetSuccess);
        context.pop();
      case PinUpdated():
        pinNotifier.setPinStatus(true);
        _showSuccessSnackbar(context, context.strings.pinUpdatedSuccess);
        context.pop();
      case PinConfirmed():
        pinNotifier.setPinStatus(true);
        context.go(AppRouter.initialLocation);
      case PinDeleted():
        pinNotifier.setPinStatus(false);
        biometricNotifier.setBiometricEnabled(false);
        _showSuccessSnackbar(context, context.strings.pinDeletedSuccess);
        context.pop();
      case PinError(:final message):
        _showErrorSnackbar(context, message);
      case PinValidationFailed():
        _showErrorSnackbar(context, context.strings.pinValidationFailed);
      default:
        break;
    }
  }

  String _getTitle(BuildContext context, PinActionType type) {
    return switch (type) {
      PinActionType.set => context.strings.setPinTitle,
      PinActionType.update => context.strings.updatePinTitle,
      PinActionType.delete => context.strings.deletePinTitle,
      PinActionType.confirm => context.strings.confirmPinTitle,
    };
  }

  void _showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

/// Содержимое экрана операций с PIN-кодом
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Expanded(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  if (actionType == PinActionType.update ||
                      actionType == PinActionType.delete ||
                      actionType == PinActionType.confirm)
                    _PinInputField(
                      label: context.strings.currentPinLabel,
                      controller: pinController,
                    ),
                  if (actionType == PinActionType.set ||
                      actionType == PinActionType.update)
                    _PinInputField(
                      label: actionType == PinActionType.set
                          ? context.strings.newPinLabel
                          : context.strings.confirmNewPinLabel,
                      controller: actionType == PinActionType.set
                          ? pinController
                          : newPinController,
                    ),
                ],
              ),
            ),
          ),
          if (actionType == PinActionType.confirm) const _BiometricAuthOption(),
          const SizedBox(height: 24),
          _ConfirmButton(isLoading: isLoading, onPressed: onConfirmPressed),
        ],
      ),
    );
  }
}

/// Поле ввода PIN-кода
class _PinInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _PinInputField({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: true,
        maxLength: 4,
        keyboardType: TextInputType.number,
        style: context.texts.bodyLarge_.copyWith(
          color: context.colors.onSurfaceText,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: context.texts.bodyLarge_.copyWith(
            color: context.colors.onSurfaceText,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: context.colors.primary),
          ),
        ),
        validator: _pinValidator,
      ),
    );
  }

  String? _pinValidator(String? value) {
    if (value == null || value.length != 4) return 'Введите 4 цифры';
    if (!RegExp(r'^\d{4}$').hasMatch(value)) return 'Только цифры';
    return null;
  }
}

/// Кнопка подтверждения
class _ConfirmButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _ConfirmButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: context.colors.primary,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                context.strings.confirmButton,
                style: context.texts.bodyLarge_.copyWith(color: Colors.white),
              ),
      ),
    );
  }
}

/// Опция биометрической аутентификации
class _BiometricAuthOption extends StatelessWidget {
  const _BiometricAuthOption();

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

            return Column(
              children: [
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: state is BiometricAuthenticating
                        ? null
                        : () => _authenticateWithBiometrics(context),
                    icon: Icon(
                      Icons.fingerprint,
                      color: context.colors.primary,
                    ),
                    label: state is BiometricAuthenticating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            context.strings.biometricAuthButton,
                            style: context.texts.bodyLarge_.copyWith(
                              color: context.colors.primary,
                            ),
                          ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: context.colors.primary),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _authenticateWithBiometrics(BuildContext context) async {
    final cubit = context.read<BiometricAuthCubit>();
    await cubit.authenticate();

    if (cubit.state is BiometricSuccess && context.mounted) {
      context.read<PinStatusNotifier>().setPinStatus(true);
      context.read<PinOperationCubit>().confirmWithoutPin();
      context.go(AppRouter.initialLocation);
    }
  }
}
