import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/app/theme/app_colors_scheme.dart';
import 'package:yandex_school_homework/app/theme/texts_extension.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_entity.dart';
import 'package:yandex_school_homework/features/accounts/domain/state/account_cubit.dart';
import 'package:yandex_school_homework/features/accounts/domain/state/account_state.dart';
import 'package:yandex_school_homework/features/accounts/presentation/components/currency_bottom_sheet.dart';
import 'package:yandex_school_homework/features/accounts/presentation/components/name_edit_bottom_sheet.dart';
import 'package:yandex_school_homework/features/accounts/presentation/components/shimmer_text.dart';
import 'package:yandex_school_homework/features/common/ui/app_error_screen.dart';
import 'package:yandex_school_homework/features/common/ui/custom_app_bar.dart';
import 'package:yandex_school_homework/features/common/ui/parametres_bar_wrapper.dart';
import 'package:yandex_school_homework/features/transactions/presentation/componenets/transactions_diagram.dart';

/// Экран счета
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        return switch (state) {
          AccountLoadingState() => const Center(
            child: CircularProgressIndicator(),
          ),
          AccountErrorState() => AppErrorScreen(
            errorMessage: state.errorMessage,
            onError: () => context.read<AccountCubit>().fetchAccount(),
          ),
          AccountLoadedState() => _AccountSuccessScreen(account: state.account),
        };
      },
    );
  }
}

/// Экран счета после успешной загрузки
class _AccountSuccessScreen extends StatefulWidget {
  const _AccountSuccessScreen({required this.account});

  final AccountEntity account;

  @override
  State<_AccountSuccessScreen> createState() => _AccountSuccessScreenState();
}

class _AccountSuccessScreenState extends State<_AccountSuccessScreen>
    with SingleTickerProviderStateMixin {
  late StreamSubscription<AccelerometerEvent> _accelerometerSub;
  bool _isBalanceHidden = false;
  DateTime? _lastShakeTime;

  // TODO: подогнать значения под более естественную тряску
  /// Время, принимаемое за одну "тряску"
  static const shakeCoolDown = Duration(seconds: 1);

  /// Магнитуда движения, принимаемого за "тряску"
  static const shakeThreshold = 20;

  /// Порог переворота по оси Z
  static const flipThreshold = -8;

  @override
  void initState() {
    super.initState();
    _accelerometerSub = accelerometerEventStream().listen(_handleAccelerometer);
  }

  /// Метод определения поворота экрана и тряски
  void _handleAccelerometer(AccelerometerEvent event) {
    final now = DateTime.now().toUtc();

    // Проверка debounce
    if (_lastShakeTime != null &&
        now.difference(_lastShakeTime!) < shakeCoolDown) {
      return;
    }

    final z = event.z;
    final magnitude = sqrt(
      event.x * event.x + event.y * event.y + event.z * event.z,
    );

    // Поворот вниз головой
    if (z < flipThreshold) {
      _toggleBalanceVisibility();
      _lastShakeTime = now;
      return;
    }

    // Сильная тряска
    if (magnitude > shakeThreshold) {
      _toggleBalanceVisibility();
      _lastShakeTime = now;
    }
  }

  /// Метод переключения видисости баланса
  void _toggleBalanceVisibility() {
    setState(() => _isBalanceHidden = !_isBalanceHidden);
  }

  @override
  void dispose() {
    _accelerometerSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final account = widget.account;
    final balanceText = '${account.balance} ${account.currency}';
    final balanceTextWidget = Text(
      balanceText,
      style: context.texts.bodyLarge_,
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: context.strings.my_account,
        nextIcon: const Icon(Icons.edit_rounded),
        onNext: () {},
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<AccountCubit>().fetchAccount(),
        child: ListView(
          children: [
            ParametersBarWrapper(
              children: [
                Text(context.strings.balance, style: context.texts.bodyLarge_),
                Row(
                  spacing: 22,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: _isBalanceHidden
                          ? ShimmerText(
                              key: const ValueKey('hidden'),
                              child: balanceTextWidget,
                            )
                          : balanceTextWidget,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: context.colors.labelsTertiary,
                    ),
                  ],
                ),
              ],
            ),
            ParametersBarWrapper(
              onTap: () => showCurrencyBottomSheet(context, account),
              children: [
                Text(context.strings.currency, style: context.texts.bodyLarge_),
                Row(
                  spacing: 22,
                  children: [
                    Text(account.currency, style: context.texts.bodyLarge_),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: context.colors.labelsTertiary,
                    ),
                  ],
                ),
              ],
            ),
            ParametersBarWrapper(
              onTap: () => showNameEditBottomSheet(context, account),
              isLast: true,
              children: [
                Text(
                  context.strings.account_name,
                  style: context.texts.bodyLarge_,
                ),
                Row(
                  spacing: 22,
                  children: [
                    Text(account.name, style: context.texts.bodyLarge_),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: context.colors.labelsTertiary,
                    ),
                  ],
                ),
              ],
            ),
            const TransactionsDiagram(),
          ],
        ),
      ),
    );
  }
}
