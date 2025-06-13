import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    super.key,
    required this.error,
    required this.stackTrace,
    this.onRetry,
  });

  final Object? error;
  final StackTrace? stackTrace;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('Перезагрузить приложение'),
                ),
                const SizedBox(height: 16),
                Text('''
          Что-то пошло не так, попробуйте перезагрузить приложение
          error: $error
                stackTrace: $stackTrace
                  ''', textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
