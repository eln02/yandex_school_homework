import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/cash_flow_analysis_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/daily_analysis_extension.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/transactions_cubit.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/transactions_state.dart';
import 'package:yandex_school_homework/features/transactions/presentation/componenets/transactions_diagram.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TransactionsCubit(context.di.repositories.transactionsRepository),
      child: const _DebugScreenView(),
    );
  }
}

class _DebugScreenView extends StatefulWidget {
  const _DebugScreenView();

  @override
  State<_DebugScreenView> createState() => _DebugScreenViewState();
}

class _DebugScreenViewState extends State<_DebugScreenView> {
  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  /// Метод получения транзакций
  Future<void> _fetchTransactions() async {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    context.read<TransactionsCubit>().fetchTransactions(
      accountId: 140,
      startDate: _formatDate(thirtyDaysAgo),
      endDate: _formatDate(now),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Отладка графика'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchTransactions,
          ),
        ],
      ),
      body: BlocBuilder<TransactionsCubit, TransactionsState>(
        builder: (context, state) {
          return switch (state) {
            TransactionsLoadingState() => const Center(
              child: CircularProgressIndicator(),
            ),
            TransactionsErrorState(errorMessage: final message) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ошибка: $message',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _fetchTransactions,
                  child: const Text('Повторить попытку'),
                ),
              ],
            ),
            TransactionsLoadedState() => SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'График денежного потока за последние 30 дней',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      height: 250,
                      child: CashFlowChart(data: state.dailyCashFlowLast30Days),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildDataTable(state.dailyCashFlowLast30Days),
                  ),
                ],
              ),
            ),
          };
        },
      ),
    );
  }

  Widget _buildDataTable(List<CashFlowAnalysisEntity> data) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Дата')),
        DataColumn(label: Text('Баланс'), numeric: true),
      ],
      rows: data.map((item) {
        return DataRow(
          cells: [
            DataCell(Text(_formatDate(item.date))),
            DataCell(Text(
              '${item.flow.toStringAsFixed(2)} ₽',
              style: TextStyle(
                color: item.flow < 0 ? Colors.red : Colors.green,
              ),
            )),
          ],
        );
      }).toList(),
    );
  }
}