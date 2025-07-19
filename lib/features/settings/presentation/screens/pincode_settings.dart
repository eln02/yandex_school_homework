import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yandex_school_homework/features/settings/presentation/domain/state/biometric_auth/biometric_status_notifier.dart';
import 'package:yandex_school_homework/features/settings/presentation/domain/state/pin_status_notifier.dart';
import 'package:yandex_school_homework/features/settings/presentation/screens/pincode_screen.dart';
import 'package:yandex_school_homework/router/app_router.dart';

class PinSettingsScreen extends StatelessWidget {
  const PinSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pinStatusNotifier = context.watch<PinStatusNotifier>();
    final biometricNotifier = context.watch<BiometricStatusNotifier>();

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки PIN')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder<bool>(
          valueListenable: pinStatusNotifier,
          builder: (context, isPinSet, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isPinSet) ...[
                  ElevatedButton(
                    onPressed: () {
                      context.pushNamed(
                        AppRouter.pinUpdate,
                        extra: PinActionType.update,
                      );
                    },
                    child: const Text('Сменить PIN'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context.pushNamed(
                        AppRouter.pinDelete,
                        extra: PinActionType.delete,
                      );
                    },
                    child: const Text('Удалить PIN'),
                  ),
                ] else ...[
                  ElevatedButton(
                    onPressed: () {
                      context.pushNamed(
                        AppRouter.pinSet,
                        extra: PinActionType.set,
                      );
                    },
                    child: const Text('Установить PIN'),
                  ),
                ],
                const SizedBox(height: 24),
                if (isPinSet)
                  ValueListenableBuilder<bool>(
                    valueListenable: biometricNotifier,
                    builder: (context, isBiometricEnabled, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Вход по биометрии'),
                          Switch(
                            value: isBiometricEnabled,
                            onChanged: biometricNotifier.setBiometricEnabled,
                          ),
                        ],
                      );
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
