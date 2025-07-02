import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/app/theme/app_colors_scheme.dart';
import 'package:yandex_school_homework/app/theme/texts_extension.dart';
import 'package:yandex_school_homework/features/accounts/domain/state/account_cubit.dart';
import 'package:yandex_school_homework/features/accounts/domain/state/account_state.dart';
import 'package:yandex_school_homework/features/categories/domain/state/categories_cubit.dart';
import 'package:yandex_school_homework/features/categories/domain/state/categories_state.dart';
import 'package:yandex_school_homework/features/common/ui/custom_app_bar.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_request_entity.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';

class TransactionEditNotifier extends ChangeNotifier {
  final TransactionResponseEntity _originalTransaction;

  int _accountId;
  int _categoryId;
  String _amount;
  DateTime _transactionDate;
  String? _comment;

  TransactionEditNotifier(this._originalTransaction)
    : _accountId = _originalTransaction.account.id,
      _categoryId = _originalTransaction.category.id,
      _amount = _originalTransaction.amount.toString(),
      _transactionDate = _originalTransaction.transactionDate,
      _comment = _originalTransaction.comment;

  int get accountId => _accountId;

  int get categoryId => _categoryId;

  String get amount => _amount;

  DateTime get transactionDate => _transactionDate.toLocal();

  String? get comment => _comment;

  String get formattedDate =>
      DateFormat('dd.MM.yyyy').format(_transactionDate.toLocal());

  String get formattedTime =>
      DateFormat('HH:mm').format(_transactionDate.toLocal());

  void updateAccount(int id) {
    _accountId = id;
    notifyListeners();
  }

  void updateCategory(int id) {
    _categoryId = id;
    notifyListeners();
  }

  void updateAmount(String value) {
    _amount = value;
    notifyListeners();
  }

  void updateDate(DateTime date) {
    _transactionDate = date;
    notifyListeners();
  }

  void updateComment(String? value) {
    _comment = value;
    notifyListeners();
  }

  TransactionRequestEntity buildRequest() {
    return TransactionRequestEntity(
      accountId: _accountId,
      categoryId: _categoryId,
      amount: _amount,
      transactionDate: _transactionDate,
      comment: _comment,
    );
  }
}

Future<TransactionRequestEntity?> showTransactionEditModal({
  required BuildContext context,
  required TransactionResponseEntity transaction,
}) async {
  return await showModalBottomSheet<TransactionRequestEntity>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: context.colors.mainBackground,
    builder: (context) => ChangeNotifierProvider(
      create: (_) => TransactionEditNotifier(transaction),
      child: Builder(
        builder: (innerContext) => TransactionEditModal(
          notifier: innerContext.read<TransactionEditNotifier>(),
        ),
      ),
    ),
  );
}

class TransactionEditModal extends StatelessWidget {
  final TransactionEditNotifier notifier;

  const TransactionEditModal({super.key, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomAppBar(
          title: 'Редактирование',
          nextIcon: const Icon(Icons.check),
          backIcon: const Icon(Icons.close),
          onNext: () => context.pop(notifier.buildRequest()),
          showBackButton: true,
        ),
        Expanded(
          child: Consumer<TransactionEditNotifier>(
            builder: (context, notifier, _) {
              return ListView(
                children: [
                  _AccountField(
                    accountId: notifier.accountId,
                    onChanged: notifier.updateAccount,
                  ),
                  _CategoryField(
                    categoryId: notifier.categoryId,
                    isIncome: notifier._originalTransaction.category.isIncome,
                    onChanged: notifier.updateCategory,
                  ),
                  _AmountField(
                    amount: notifier.amount,
                    onChanged: notifier.updateAmount,
                  ),
                  _DateField(
                    date: notifier.transactionDate,
                    onChanged: notifier.updateDate,
                  ),
                  _TimeField(
                    time: notifier.transactionDate,
                    onChanged: notifier.updateDate,
                  ),
                  _CommentField(
                    comment: notifier.comment,
                    onChanged: notifier.updateComment,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const _DateField({required this.date, required this.onChanged});

  Future<void> _selectDate(BuildContext context, DateTime currentDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: context.colors.financeGreen,
            surface: context.colors.mainBackground,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      onChanged(
        DateTime(
          picked.year,
          picked.month,
          picked.day,
          currentDate.hour,
          currentDate.minute,
        ).toUtc(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd.MM.yyyy').format(date.toLocal());

    return _FieldWrapper(
      label: 'Дата',
      child: GestureDetector(
        onTap: () => _selectDate(context, date),
        child: AbsorbPointer(
          child: Text(
            formattedDate,
            style: context.texts.bodyLarge_.copyWith(
              color: context.colors.onSurfaceText,
            ),
          ),
        ),
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  final DateTime time;
  final ValueChanged<DateTime> onChanged;

  const _TimeField({required this.time, required this.onChanged});

  Future<void> _selectTime(BuildContext context, DateTime currentTime) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentTime),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: context.colors.financeGreen,
            surface: context.colors.mainBackground,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      onChanged(
        DateTime(
          currentTime.year,
          currentTime.month,
          currentTime.day,
          picked.hour,
          picked.minute,
        ).toUtc(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('HH:mm').format(time.toLocal());

    return _FieldWrapper(
      label: 'Время',
      child: GestureDetector(
        onTap: () => _selectTime(context, time),
        child: AbsorbPointer(
          child: Text(
            formattedTime,
            style: context.texts.bodyLarge_.copyWith(
              color: context.colors.onSurfaceText,
            ),
          ),
        ),
      ),
    );
  }
}

class _AccountField extends StatelessWidget {
  final int accountId;
  final ValueChanged<int> onChanged;

  const _AccountField({required this.accountId, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _FieldWrapper(
      label: 'Счет',
      child: BlocBuilder<AccountCubit, AccountState>(
        builder: (context, state) {
          switch (state) {
            case AccountLoadedState():
              final accounts = state.accounts;

              return DropdownButton<int>(
                alignment: Alignment.centerRight,
                value: accountId,
                items: accounts.map((account) {
                  return DropdownMenuItem<int>(
                    value: account.id,
                    child: Text(
                      account.name,
                      style: context.texts.bodyLarge_.copyWith(
                        color: context.colors.onSurfaceText,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) onChanged(value);
                },
                isExpanded: true,
                underline: Container(),
                selectedItemBuilder: (context) {
                  return accounts.map((account) {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        account.name,
                        style: context.texts.bodyLarge_.copyWith(
                          color: context.colors.onSurfaceText,
                        ),
                      ),
                    );
                  }).toList();
                },
              );

            case AccountErrorState():
              return Text(
                'Ошибка загрузки',
                style: context.texts.bodyLarge_.copyWith(
                  color: context.colors.error,
                ),
              );

            case AccountLoadingState():
              return const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              );
          }
        },
      ),
    );
  }
}

class _CategoryField extends StatelessWidget {
  final int categoryId;
  final bool isIncome;
  final ValueChanged<int> onChanged;

  const _CategoryField({
    required this.categoryId,
    required this.isIncome,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _FieldWrapper(
      label: 'Статья',
      child: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          switch (state) {
            case CategoriesLoadedState():
              final categories = isIncome
                  ? state.incomeCategories
                  : state.expenseCategories;

              return DropdownButton<int>(
                alignment: Alignment.centerRight,
                value: categoryId,
                items: categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category.id,
                    child: Text(
                      category.name,
                      style: context.texts.bodyLarge_.copyWith(
                        color: context.colors.onSurfaceText,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) onChanged(value);
                },
                isExpanded: true,
                underline: Container(),
                selectedItemBuilder: (context) {
                  return categories.map((category) {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        category.name,
                        style: context.texts.bodyLarge_.copyWith(
                          color: context.colors.onSurfaceText,
                        ),
                      ),
                    );
                  }).toList();
                },
              );

            case CategoriesErrorState():
              return Text(
                'Ошибка загрузки категорий',
                style: context.texts.bodyLarge_.copyWith(
                  color: context.colors.error,
                ),
              );

            case CategoriesLoadingState():
              return const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              );
          }
        },
      ),
    );
  }
}

class _AmountField extends StatelessWidget {
  final String amount;
  final ValueChanged<String> onChanged;

  const _AmountField({required this.amount, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _FieldWrapper(
      label: 'Сумма',
      child: TextFormField(
        initialValue: amount,
        onChanged: onChanged,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        ],
        textAlign: TextAlign.end,
        style: context.texts.bodyLarge_.copyWith(
          color: context.colors.onSurfaceText,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: '0',
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

class _CommentField extends StatelessWidget {
  final String? comment;
  final ValueChanged<String?> onChanged;

  const _CommentField({required this.comment, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _FieldWrapper(
      child: TextFormField(
        initialValue: comment,
        onChanged: (value) => onChanged(value.isEmpty ? null : value),
        style: context.texts.bodyLarge_.copyWith(
          color: context.colors.onSurfaceText,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Комментарий',
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

class _FieldWrapper extends StatelessWidget {
  final String? label;
  final Widget child;

  const _FieldWrapper({this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: context.colors.transactionsDivider,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (label != null)
            Expanded(
              flex: 2,
              child: Text(
                label!,
                style: context.texts.bodyLarge_.copyWith(
                  color: context.colors.onSurfaceText,
                ),
              ),
            ),
          Expanded(
            flex: 3,
            child: Align(alignment: Alignment.centerRight, child: child),
          ),
        ],
      ),
    );
  }
}
