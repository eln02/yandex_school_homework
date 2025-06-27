import 'package:flutter/material.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  Future<void> _clearDatabase(BuildContext context) async {
    await context.di.databaseService.clearDatabase();
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('База данных очищена')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => _clearDatabase(context),
              icon: const Icon(Icons.delete_outline),
              style: IconButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 8),
            const Text('Очистить базу данных', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
