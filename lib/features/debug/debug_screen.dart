import 'package:flutter/material.dart';
import 'package:yandex_school_homework/features/accounts/presentation/screens/diagram.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug Screen')),
      body: Center(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(height: 200, child: BarChartSample()),
      )),
    );
  }
}
