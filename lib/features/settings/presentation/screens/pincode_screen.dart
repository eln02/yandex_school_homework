import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
              context.pop();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Пин удален')));
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (isUpdate || isDelete || isConfirm)
                    TextFormField(
                      controller: _pinController,
                      obscureText: true,
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Текущий PIN',
                      ),
                      validator: _pinValidator,
                    ),
                  if (isSet || isUpdate)
                    TextFormField(
                      controller: isSet ? _pinController : _newPinController,
                      obscureText: true,
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Новый PIN'),
                      validator: _pinValidator,
                    ),
                  const SizedBox(height: 24),
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
            ),
          );
        },
      ),
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
