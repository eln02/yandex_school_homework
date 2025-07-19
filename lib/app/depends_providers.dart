import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_school_homework/app/theme/theme_notifier.dart';
import 'package:yandex_school_homework/di/di_container.dart';
import 'package:provider/provider.dart';
import 'package:yandex_school_homework/features/accounts/domain/state/account_cubit.dart';
import 'package:yandex_school_homework/features/categories/domain/state/categories_cubit.dart';
import 'package:yandex_school_homework/features/connectivity_checker/backup_cubit.dart';
import 'package:yandex_school_homework/features/settings/presentation/domain/state/biometric_auth/biometric_auth_cubit.dart';
import 'package:yandex_school_homework/features/settings/presentation/domain/state/biometric_auth/biometric_status_notifier.dart';
import 'package:yandex_school_homework/features/settings/presentation/domain/state/pin_status_notifier.dart';
import 'package:yandex_school_homework/features/settings/presentation/domain/state/pincode_cubit.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/transaction/transacton_cubit.dart';
import 'package:yandex_school_homework/features/transactions/domain/state/transactions_cubit.dart';

final class DependsProviders extends StatelessWidget {
  const DependsProviders({
    super.key,
    required this.child,
    required this.diContainer,
  });

  final Widget child;
  final DiContainer diContainer;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: diContainer),
        // аккаунты и категории загружаются глобально чтобы не загружать
        // каждый раз при открытии окна создании/редактировании транзакции
        BlocProvider(
          /// глобальный кубит аккаунтов
          create: (context) =>
              AccountCubit(diContainer.repositories.accountsRepository)
                ..fetchAccount(),
        ),
        BlocProvider(
          /// глобальный кубит категорий
          create: (context) =>
              CategoriesCubit(diContainer.repositories.categoriesRepository)
                ..fetchCategories(),
        ),
        BlocProvider(
          /// глобальный кубит транзакций для экрнов доходов и расходов
          create: (context) => TransactionsCubit(
            diContainer.repositories.transactionsRepository,
          ),
        ),
        BlocProvider(
          /// кубит для создания транзакции
          create: (_) => TransactionOperationCubit(
            diContainer.repositories.transactionsRepository,
          ),
        ),
        BlocProvider(
          /// кубит для выполнения бэкапов при появлении интернета
          create: (_) => BackupCubit(
            connectivity: Connectivity(),
            accountsRepository: diContainer.repositories.accountsRepository,
            transactionsRepository:
                diContainer.repositories.transactionsRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeNotifier(diContainer.userSettingsService),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              PinStatusNotifier(isPinSet: diContainer.pinCodeService.isPinSet),
        ),
        ChangeNotifierProvider(
          create: (_) => BiometricStatusNotifier(diContainer.pinCodeService),
        ),
        BlocProvider(
          create: (_) => PinOperationCubit(diContainer.pinCodeService),
        ),
        BlocProvider(
          create: (_) =>
              BiometricAuthCubit(diContainer.biometricAuthService)
                ..checkAvailability(),
        ),
      ],
      child: child,
    );
  }
}
