import 'package:flutter/material.dart';

/// Экран ошибки загрузки
// TODO: добавить дизайн
// TODO: вынести глобально, если будет использоваться на других экранах
class AppErrorScreen extends StatelessWidget {
  const AppErrorScreen({
    super.key,
    required this.onError,
    required this.errorMessage,
  });

  final VoidCallback onError;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage),
            ElevatedButton(onPressed: onError, child: const Text('Повторить')),
          ],
        ),
      ),
    );
  }
}
