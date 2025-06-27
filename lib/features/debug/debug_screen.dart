import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  String _resultText = 'Результат пока пуст';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // растягивает элементы по ширине
          children: [
            ElevatedButton(
              onPressed: () async {
                final repository = context.di.repositories.accountsRepository;
                final result = await repository.fetchAccounts();
                setState(() {
                  _resultText = _formatResult(result);
                });
              },
              child: const Text('Получить данные аккаунтов'),
            ),
            ElevatedButton(
              onPressed: () async {
                final repository = context.di.repositories.categoriesRepository;
                final result = await repository.fetchCategories();
                setState(() {
                  _resultText = _formatResult(result);
                });
              },
              child: const Text('Получить данные категорий'),
            ),
            ElevatedButton(
              onPressed: () async {
               /* final repository =
                    context.di.repositories.transactionsRepository;
                final result = await repository.fetchTransactionById(40);
                setState(() {
                  _resultText = _formatResult(result);
                });*/
              },
              child: const Text('Получить данные транзакций'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Результат:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(child: Text(_resultText)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatResult(Object? result) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(result);
    } catch (e) {
      return result.toString();
    }
  }
}
