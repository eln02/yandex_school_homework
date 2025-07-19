import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/app/theme/app_colors_scheme.dart';
import 'package:yandex_school_homework/features/common/ui/custom_app_bar.dart';
import 'package:yandex_school_homework/features/settings/domain/state/biometric_auth/biometric_status_notifier.dart';
import 'package:yandex_school_homework/features/settings/domain/state/pincode_auth/pin_status_notifier.dart';
import 'package:yandex_school_homework/features/settings/presentation/components/settings_tile.dart';
import 'package:yandex_school_homework/features/settings/presentation/screens/pincode_screen.dart';
import 'package:yandex_school_homework/router/app_router.dart';

/// Экран настроек PIN-кода и биометрии
class PinSettingsScreen extends StatelessWidget {
  const PinSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.mainBackground,
      appBar: CustomAppBar(
        title: context.strings.pinSettingsTitle,
        showBackButton: true,
      ),
      body: const _PinSettingsContent(),
    );
  }
}

/// Основное содержимое экрана настроек
class _PinSettingsContent extends StatelessWidget {
  const _PinSettingsContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [_PinManagementSection(), _BiometricSection()],
    );
  }
}

/// Секция управления PIN-кодом
class _PinManagementSection extends StatelessWidget {
  const _PinManagementSection();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: context.read<PinStatusNotifier>(),
      builder: (context, isPinSet, _) {
        return isPinSet
            ? const _PinModificationOptions()
            : const _SetPinOption();
      },
    );
  }
}

/// Опция установки PIN-кода
class _SetPinOption extends StatelessWidget {
  const _SetPinOption();

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      leading: const Icon(Icons.lock_outline),
      title: context.strings.setPinButton,
      onTap: () => _navigateToPinScreen(context, PinActionType.set),
    );
  }
}

/// Опции изменения и удаления PIN-кода
class _PinModificationOptions extends StatelessWidget {
  const _PinModificationOptions();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingsTile(
          leading: const Icon(Icons.lock_reset),
          title: context.strings.changePinButton,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _navigateToPinScreen(context, PinActionType.update),
        ),
        SettingsTile(
          leading: const Icon(Icons.lock_open),
          title: context.strings.removePinButton,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _navigateToPinScreen(context, PinActionType.delete),
        ),
      ],
    );
  }
}

/// Секция биометрической аутентификации
class _BiometricSection extends StatelessWidget {
  const _BiometricSection();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: context.read<PinStatusNotifier>(),
      builder: (context, isPinSet, _) {
        return isPinSet ? const _BiometricOption() : const SizedBox.shrink();
      },
    );
  }
}

/// Опция биометрической аутентификации
class _BiometricOption extends StatelessWidget {
  const _BiometricOption();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: context.read<BiometricStatusNotifier>(),
      builder: (context, isBiometricEnabled, _) {
        return SettingsTile(
          leading: const Icon(Icons.fingerprint),
          title: context.strings.biometricAuthLabel,
          trailing: CupertinoSwitch(
            value: isBiometricEnabled,
            onChanged: context
                .read<BiometricStatusNotifier>()
                .setBiometricEnabled,
            activeTrackColor: context.colors.primary,
            inactiveTrackColor: context.colors.secondary,
          ),
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
