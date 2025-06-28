import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/app/theme/app_colors_scheme.dart';
import 'package:yandex_school_homework/app/theme/texts_extension.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_entity.dart';
import 'package:yandex_school_homework/features/accounts/domain/state/account_cubit.dart';

/// Перечисление валют
// TODO: доработать и вынести глобально для замены кода валюты на символ
enum Currency {
  rub('RUB', 'Российский рубль', '₽'),
  usd('USD', 'Американский доллар', '\u0024'), // тк $ символ экранирования
  eur('EUR', 'Евро', '€');

  final String code;
  final String name;
  final String symbol;

  const Currency(this.code, this.name, this.symbol);
}

/// Модальное окно выбора валюты
void showCurrencyBottomSheet(BuildContext context, AccountEntity account) {
  showModalBottomSheet(
    backgroundColor: context.colors.mainBackground,
    useRootNavigator: true,
    context: context,
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: context.colors.modalLine,
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              const SizedBox(height: 16),
              ...Currency.values.map((currency) {
                return ListTile(
                  leading: Text(
                    currency.symbol,
                    style: context.texts.titleLarge_,
                  ),
                  title: Text(
                    '${currency.name}, ${currency.code}',
                    style: context.texts.bodyLarge_,
                  ),
                  trailing: account.currency == currency.code
                      ? Icon(Icons.check, color: context.colors.financeGreen)
                      : null,
                  onTap: () {
                    context.pop();
                    context.read<AccountCubit>().updateAccount(
                      currency: currency.code,
                    );
                  },
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    },
  );
}
