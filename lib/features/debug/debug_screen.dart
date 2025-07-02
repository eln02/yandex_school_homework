import 'package:flutter/material.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/category_analysis_entity.dart';

import 'package:yandex_school_homework/features/transactions/presentation/componenets/diagram.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  bool _showFirst = true;

  final List<CategoryAnalysisEntity> dataSet1 = const [
    CategoryAnalysisEntity(
      id: 1,
      name: "Продукты",
      emoji: "🛒",
      percent: 35.0,
      amount: 7000,
      transactions: [],
    ),
    CategoryAnalysisEntity(
      id: 2,
      name: "Транспорт",
      emoji: "🚌",
      percent: 25.0,
      amount: 5000,
      transactions: [],
    ),
    CategoryAnalysisEntity(
      id: 3,
      name: "Развлечения",
      emoji: "🎮",
      percent: 20.0,
      amount: 4000,
      transactions: [],
    ),
    CategoryAnalysisEntity(
      id: 4,
      name: "Одежда",
      emoji: "👗",
      percent: 20.0,
      amount: 4000,
      transactions: [],
    ),
  ];

  final List<CategoryAnalysisEntity> dataSet2 = const [
    CategoryAnalysisEntity(
      id: 5,
      name: "Здоровье",
      emoji: "💊",
      percent: 40.0,
      amount: 8000,
      transactions: [],
    ),
    CategoryAnalysisEntity(
      id: 6,
      name: "Путешествия",
      emoji: "✈️",
      percent: 30.0,
      amount: 6000,
      transactions: [],
    ),
    CategoryAnalysisEntity(
      id: 7,
      name: "Дом",
      emoji: "🏠",
      percent: 30.0,
      amount: 6000,
      transactions: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final oldData = _showFirst ? dataSet1 : dataSet2;
    final newData = _showFirst ? dataSet2 : dataSet1;

    return Scaffold(
      appBar: AppBar(title: const Text('Debug Screen')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: 250,
              child: AnimatedPieChartSwitcher(
                key: ValueKey(_showFirst), // ключ нужен для перерисовки
                oldData: oldData,
                newData: newData,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _showFirst = !_showFirst;
              });
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Сменить данные'),
          ),
        ],
      ),
    );
  }
}
