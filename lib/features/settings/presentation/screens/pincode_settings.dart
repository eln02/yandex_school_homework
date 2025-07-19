import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yandex_school_homework/features/settings/presentation/domain/state/biometric_auth/biometric_status_notifier.dart';
import 'package:yandex_school_homework/features/settings/presentation/domain/state/pin_status_notifier.dart';
import 'package:yandex_school_homework/features/settings/presentation/screens/pincode_screen.dart';
import 'package:yandex_school_homework/router/app_router.dart';

/// Экран настроек PIN-кода и биометрии
class PinSettingsScreen extends StatelessWidget {
  const PinSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки PIN')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: _PinSettingsContent(),
      ),
    );
  }
}

/// Основное содержимое экрана настроек
class _PinSettingsContent extends StatelessWidget {
  const _PinSettingsContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PinManagementButtons(),
        SizedBox(height: 24),
        _BiometricToggle(),
      ],
    );
  }
}

/// Кнопки управления PIN-кодом (установка/изменение/удаление)
class _PinManagementButtons extends StatelessWidget {
  const _PinManagementButtons();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: context.read<PinStatusNotifier>(),
      builder: (context, isPinSet, _) {
        return isPinSet
            ? const _PinModificationButtons()
            : const _SetPinButton();
      },
    );
  }
}

/// Кнопка установки PIN-кода
class _SetPinButton extends StatelessWidget {
  const _SetPinButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _navigateToPinScreen(context, PinActionType.set),
      child: const Text('Установить PIN'),
    );
  }
}

/// Кнопки изменения и удаления PIN-кода
class _PinModificationButtons extends StatelessWidget {
  const _PinModificationButtons();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _navigateToPinScreen(context, PinActionType.update),
          child: const Text('Сменить PIN'),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => _navigateToPinScreen(context, PinActionType.delete),
          child: const Text('Удалить PIN'),
        ),
      ],
    );
  }
}

/// Переключатель биометрической аутентификации
class _BiometricToggle extends StatelessWidget {
  const _BiometricToggle();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: context.read<PinStatusNotifier>(),
      builder: (context, isPinSet, _) {
        return isPinSet ? const _BiometricSwitch() : const SizedBox.shrink();
      },
    );
  }
}

/// Сам переключатель биометрии
class _BiometricSwitch extends StatelessWidget {
  const _BiometricSwitch();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: context.read<BiometricStatusNotifier>(),
      builder: (context, isBiometricEnabled, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Вход по биометрии'),
            Switch(
              value: isBiometricEnabled,
              onChanged: context
                  .read<BiometricStatusNotifier>()
                  .setBiometricEnabled,
            ),
          ],
        );
      },
    );
  }
}

/// Навигация к экрану работы с PIN-кодом
void _navigateToPinScreen(BuildContext context, PinActionType actionType) {
  context.pushNamed(_getRouteName(actionType), extra: actionType);
}

/// Получение имени маршрута по типу действия
String _getRouteName(PinActionType actionType) {
  return switch (actionType) {
    PinActionType.set => AppRouter.pinSet,
    PinActionType.update => AppRouter.pinUpdate,
    PinActionType.delete => AppRouter.pinDelete,
    PinActionType.confirm => AppRouter.pinConfirm,
  };
}
