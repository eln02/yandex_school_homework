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

enum _UpdatePinStep { validateOld, enterNew }

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
  _UpdatePinStep _updateStep = _UpdatePinStep.validateOld;

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
    final cubit = context.read<PinOperationCubit>();

    switch (widget.actionType) {
      case PinActionType.set:
        cubit.savePin(_pinController.text);
        break;
      case PinActionType.update:
        if (_updateStep == _UpdatePinStep.validateOld) {
          cubit.validatePin(_pinController.text);
        } else {
          cubit.saveUpdatedPin(_newPinController.text);
        }
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
        showBackButton: widget.actionType != PinActionType.confirm,
      ),
      body: BlocConsumer<PinOperationCubit, PinOperationState>(
        listener: (context, state) => _handlePinOperationState(context, state),
        builder: (context, state) {
          return _PinActionContent(
            formKey: _formKey,
            actionType: widget.actionType,
            updateStep: _updateStep,
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
        if (widget.actionType == PinActionType.update &&
            _updateStep == _UpdatePinStep.validateOld) {
          setState(() {
            _updateStep = _UpdatePinStep.enterNew;
            _pinController.clear();
          });
        } else {
          pinNotifier.setPinStatus(true);
          context.go(AppRouter.initialLocation);
        }
      case PinDeleted():
        pinNotifier.setPinStatus(false);
        biometricNotifier.setBiometricEnabled(false);
        _showSuccessSnackbar(context, context.strings.pinDeletedSuccess);
        context.pop();
      case PinError(:final message):
        _showErrorSnackbar(context, message);
        _pinController.clear();
        _newPinController.clear();
        setState(() {});
      case PinValidationFailed():
        _showErrorSnackbar(context, context.strings.pinValidationFailed);
        _pinController.clear();
        _newPinController.clear();
        setState(() {});
      default:
        break;
    }
  }

  String _getTitle(BuildContext context, PinActionType type) {
    return switch (type) {
      PinActionType.set => context.strings.setPinTitle,
      PinActionType.update =>
        _updateStep == _UpdatePinStep.validateOld
            ? context.strings.confirmPinTitle
            : context.strings.updatePinTitle,
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
  final _UpdatePinStep? updateStep;
  final bool isLoading;
  final TextEditingController pinController;
  final TextEditingController newPinController;
  final VoidCallback onConfirmPressed;

  const _PinActionContent({
    required this.formKey,
    required this.actionType,
    this.updateStep,
    required this.isLoading,
    required this.pinController,
    required this.newPinController,
    required this.onConfirmPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isUpdate = actionType == PinActionType.update;
    final useNewField = isUpdate && updateStep == _UpdatePinStep.enterNew;
    final label = switch (actionType) {
      PinActionType.set => context.strings.newPinLabel,
      PinActionType.confirm => context.strings.currentPinLabel,
      PinActionType.delete => context.strings.currentPinLabel,
      PinActionType.update when updateStep == _UpdatePinStep.validateOld =>
        context.strings.currentPinLabel,
      PinActionType.update when updateStep == _UpdatePinStep.enterNew =>
        context.strings.confirmNewPinLabel,
      PinActionType.update => context.strings.currentPinLabel,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const SizedBox(height: 64),
          Text(label, style: context.texts.bodyLarge_),
          const SizedBox(height: 16),
          _PinCodeField(
            controller: useNewField ? newPinController : pinController,
            onCompleted: (_) => onConfirmPressed(),
          ),
          if (actionType == PinActionType.confirm)
            const Padding(
              padding: EdgeInsets.only(top: 32),
              child: _BiometricAuthOption(),
            ),
        ],
      ),
    );
  }
}

/// Поле ввода PIN-кода из 4 квадратов
class _PinCodeField extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String) onCompleted;

  const _PinCodeField({required this.controller, required this.onCompleted});

  @override
  State<_PinCodeField> createState() => _PinCodeFieldState();
}

class _PinCodeFieldState extends State<_PinCodeField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final length = widget.controller.text.length;

    return GestureDetector(
      onTap: () => _focusNode.requestFocus(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) {
              final isFilled = index < length;
              final digit = isFilled ? widget.controller.text[index] : '';

              return Container(
                width: 50,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!, width: 2.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  digit,
                  style: context.texts.headlineSmall?.copyWith(
                    color: context.colors.onSurfaceText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }),
          ),
          TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            maxLength: 4,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.transparent),
            cursorColor: Colors.transparent,
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
            ),
            onChanged: (value) async {
              setState(() {});

              if (value.length == 4) {
                // чтобы пользователь успел увидеть 4ю цифру в поле ввода
                await Future.delayed(const Duration(milliseconds: 100));
                if (mounted) widget.onCompleted(value);
              }
            },
          ),
        ],
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
