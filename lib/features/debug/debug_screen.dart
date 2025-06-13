import 'package:flutter/material.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug Screen')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [Text('тут всякие дебаг штуки')]),
      ),
    );
  }
}
