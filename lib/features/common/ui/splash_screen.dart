import 'package:flutter/material.dart';
import 'package:yandex_school_homework/gen/assets.gen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality( // Directionality нужен тк сплеш показывается до инициализации MaterialApp
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Assets.gifs.moneyCat.image()),
      ),
    );
  }
}
