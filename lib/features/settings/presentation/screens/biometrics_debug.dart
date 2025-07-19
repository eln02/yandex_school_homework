import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/features/settings/presentation/domain/state/biometric_auth/biometric_auth_cubit.dart';
import 'package:yandex_school_homework/features/settings/presentation/domain/state/biometric_auth/biometric_auth_state.dart';

class BiometricAuthScreen extends StatelessWidget {
  const BiometricAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BiometricAuthCubit(context.di.biometricAuthService)..checkAvailability(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Биометрическая аутентификация')),
        body: BlocBuilder<BiometricAuthCubit, BiometricAuthState>(
          builder: (context, state) {
            String status = '';

            if (state is BiometricChecking) {
              status = 'Проверка доступности...';
            } else if (state is BiometricAvailable) {
              status = 'Биометрия доступна';
            } else if (state is BiometricUnavailable) {
              status = state.reason;
            } else if (state is BiometricAuthenticating) {
              status = 'Аутентификация...';
            } else if (state is BiometricSuccess) {
              status = '✅ Вход выполнен';
            } else if (state is BiometricFailure) {
              status = '❌ ${state.reason}';
            } else if (state is BiometricError) {
              status = '⚠️ ${state.message}';
            }

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      status,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () => context.read<BiometricAuthCubit>().authenticate(),
                      icon: const Icon(Icons.fingerprint),
                      label: const Text('Войти по биометрии'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
