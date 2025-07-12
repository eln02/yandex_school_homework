import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_school_homework/features/connectivity_checker/backup_cubit.dart';

class ConnectivityStatusBar extends StatelessWidget {
  const ConnectivityStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BackupCubit, bool>(
      builder: (context, isConnected) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: isConnected ? 0 : 30,
          color: Colors.orange,
          child: Center(
            child: Text(
              isConnected ? '' : 'Оффлайн режим',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}