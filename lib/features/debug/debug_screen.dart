import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/app/database/backup_operation.dart';
import 'package:yandex_school_homework/features/debug/debug_cubit.dart';
import 'package:yandex_school_homework/features/debug/debug_repository.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  List<BackupOperation> _backupOperations = [];
  bool _isLoading = false;

  Future<void> _loadBackupOperations() async {
    setState(() => _isLoading = true);
    try {
      final transactions = await context.di.databaseService
          .getUnsyncedOperations('transaction');
      final accounts = await context.di.databaseService.getUnsyncedOperations(
        'account',
      );
      final categories = await context.di.databaseService.getUnsyncedOperations(
        'category',
      );

      setState(() {
        _backupOperations = [...transactions, ...accounts, ...categories];
        _backupOperations.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      });
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackbar('Ошибка загрузки операций: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _clearDatabase() async {
    await context.di.databaseService.clearDatabase();
    if (!mounted) return;
    _showSuccessSnackbar('База данных очищена');
    await _loadBackupOperations();
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadBackupOperations();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DebugCubit(DebugRepository(httpClient: context.di.httpClient)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Debug Screen'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadBackupOperations,
              tooltip: 'Обновить',
            ),
          ],
        ),
        body: Column(
          children: [
            BlocConsumer<DebugCubit, DebugState>(
              listener: (context, state) {
                if (state is DebugError) {
                  _showErrorSnackbar('Ошибка: ${state.message}');
                }
              },
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: _clearDatabase,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete_outline, color: Colors.white),
                            Text(
                              'Очистить бд',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<DebugCubit>().trigger500Error(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: state is DebugLoading
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : const Text(
                          'Тест 500 ошибки с ретраями',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _backupOperations.isEmpty
                  ? const Center(child: Text('Нет операций в бэкапе'))
                  : ListView.builder(
                itemCount: _backupOperations.length,
                itemBuilder: (context, index) {
                  final op = _backupOperations[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${op.operationType} • ${op.entityType}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                _formatDate(op.createdAt),
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('ID: ${op.entityId}'),
                          const SizedBox(height: 8),
                          Text(
                            'Данные: ${op.payload.toString()}',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')} ${date.day}.${date.month}.${date.year}';
  }
}