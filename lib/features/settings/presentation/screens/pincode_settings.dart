import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_school_homework/features/settings/presentation/domain/state/pincode_cubit.dart';
import 'package:yandex_school_homework/features/settings/presentation/domain/state/pincode_state.dart';
import 'package:yandex_school_homework/features/settings/presentation/screens/pincode_screen.dart';
import 'package:yandex_school_homework/router/app_router.dart';

class PinSettingsScreen extends StatelessWidget {
  const PinSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки PIN')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<PinCodeCubit, PinCodeState>(
          builder: (context, state) {
            return switch (state) {
              //PinInitial(:final isPinSet) => _buildButtons(context, isPinSet),
              PinSet() || PinConfirmed() => _buildButtons(context, true),
              PinDeleted() => _buildButtons(context, false),
              PinLoading() => const Center(child: CircularProgressIndicator()),
              _ => const SizedBox.shrink(), // Неизвестное состояние — ничего не рендерим
            };
          },
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context, bool isPinSet) {
    return Column(
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
      ],
    );
  }
}
