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
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';
import 'package:yandex_school_homework/features/transactions/presentation/state/transaction_edit_result.dart';
import 'package:yandex_school_homework/features/transactions/presentation/state/transaction_notifier.dart';

/// Режим редактирования/создания транзакции
enum TransactionEditMode { create, edit }

/// Функция вызова модального окна редактирования/создания транзакции
Future<TransactionEditResult?> showTransactionEditModal({
  required BuildContext context,
  TransactionResponseEntity? transaction,
  bool? isIncome,
}) async {
  return await showModalBottomSheet<TransactionEditResult>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: context.colors.mainBackground,
    builder: (context) => ChangeNotifierProvider(
      create: (_) => transaction != null
          ? TransactionNotifier.edit(transaction)
          : TransactionNotifier.create(isIncome: isIncome),
      child: Builder(
        builder: (innerContext) => TransactionEditModal(
          notifier: innerContext.read<TransactionNotifier>(),
          mode: transaction != null
              ? TransactionEditMode.edit
              : TransactionEditMode.create,
        ),
      ),
    ),
  );
}

/// Модальное окно редактирования/создания транзакции
class TransactionEditModal extends StatelessWidget {
  final TransactionNotifier notifier;
  final TransactionEditMode mode;

  const TransactionEditModal({
    super.key,
    required this.notifier,
    this.mode = TransactionEditMode.edit,
  });

  /// Метод показа диалогового окна валидации
  Future<void> _showValidationDialog(
    BuildContext context,
    List<String> errors,
  ) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Не все поля заполнены',
            style: context.texts.titleLarge_.copyWith(
              color: context.colors.onSurfaceText,
            ),
          ),
          backgroundColor: context.colors.mainBackground,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: errors.map((error) => Text('• $error')).toList(),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: context.texts.titleLarge_.copyWith(
                  color: context.primaryColor,
                ),
              ),
              onPressed: () => context.pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomAppBar(
          title: mode == TransactionEditMode.edit
              ? 'Редактирование'
              : 'Новая транзакция',
          nextIcon: const Icon(Icons.check),
          backIcon: const Icon(Icons.close),
          onNext: () async {
            /// дебаунс при отсутсвии измений - просто закрытие
            if (mode == TransactionEditMode.edit && !notifier.hasChanges) {
              if (context.mounted) {
                context.pop(TransactionEditResult.canceled());
              }
              return;
            }

            /// валидация формы
            final errors = notifier.validateForm();
            if (errors.isNotEmpty) {
              await _showValidationDialog(context, errors);
              return;
            }

            /// создание сущности и возврат ее на прошлый экран, если все успешно
            final request = notifier.buildRequest();
            if (request != null && context.mounted) {
              context.pop(TransactionEditResult.success(request));
            }
          },
          showBackButton: true,
        ),
        Expanded(
          child: Consumer<TransactionNotifier>(
            builder: (context, notifier, _) {
              return ListView(
                children: [
                  _AccountField(
                    accountId: notifier.accountId,
                    onChanged: notifier.updateAccount,
                  ),
                  _CategoryField(
                    categoryId: notifier.categoryId,
                    isIncome: notifier.isIncome,
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
                  if (mode == TransactionEditMode.edit)
                    _DeleteButton(
                      onDelete: () {
                        context.pop(TransactionEditResult.deleted());
                      },
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

/// Кнопка удаления транзакции
class _DeleteButton extends StatelessWidget {
  final VoidCallback onDelete;

  const _DeleteButton({required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ElevatedButton(
        onPressed: onDelete,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colors.error,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
        ),
        child: Text(
          'Удалить транзакцию',
          style: context.texts.bodyLarge_.copyWith(color: context.colors.white),
        ),
      ),
    );
  }
}

/// Раздел редактирования даты
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
            primary: context.primaryColor,
            surface: context.colors.mainBackground,
            onSurface: context.colors.onSurface_,
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

/// Раздел редактирования времени
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
            primary: context.primaryColor,
            surface: context.colors.mainBackground,
            onSurface: context.colors.onSurface_,
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

/// Раздел выбора счета
class _AccountField extends StatelessWidget {
  final int? accountId;
  final ValueChanged<int?> onChanged;

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

              return DropdownButton<int?>(
                alignment: Alignment.centerRight,
                value: accountId,
                items: [
                  DropdownMenuItem<int?>(
                    value: null,
                    child: Text(
                      'Выберите счет',
                      style: context.texts.bodyLarge_.copyWith(
                        color: context.colors.onSurfaceText,
                      ),
                    ),
                  ),
                  ...accounts.map((account) {
                    return DropdownMenuItem<int?>(
                      value: account.id,
                      child: Text(
                        account.name,
                        style: context.texts.bodyLarge_.copyWith(
                          color: context.colors.onSurfaceText,
                        ),
                      ),
                    );
                  }),
                ],
                onChanged: onChanged,
                isExpanded: true,
                underline: Container(),
                selectedItemBuilder: (context) {
                  return [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Выберите счет',
                        style: context.texts.bodyLarge_.copyWith(
                          color: context.colors.onSurfaceText,
                        ),
                      ),
                    ),
                    ...accounts.map((account) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          account.name,
                          style: context.texts.bodyLarge_.copyWith(
                            color: context.colors.onSurfaceText,
                          ),
                        ),
                      );
                    }),
                  ];
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

/// Раздел выбора категории
class _CategoryField extends StatelessWidget {
  final int? categoryId;
  final bool? isIncome;
  final ValueChanged<int?> onChanged;

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
              if (isIncome == null) {
                return Text(
                  'Сначала выберите тип транзакции',
                  style: context.texts.bodyLarge_.copyWith(
                    color: context.colors.onSurfaceText,
                  ),
                );
              }

              final categories = isIncome!
                  ? state.incomeCategories
                  : state.expenseCategories;

              return DropdownButton<int?>(
                alignment: Alignment.centerRight,
                value: categoryId,
                items: [
                  DropdownMenuItem<int?>(
                    value: null,
                    child: Text(
                      'Выберите категорию',
                      style: context.texts.bodyLarge_.copyWith(
                        color: context.colors.onSurfaceText,
                      ),
                    ),
                  ),
                  ...categories.map((category) {
                    return DropdownMenuItem<int?>(
                      value: category.id,
                      child: Text(
                        category.name,
                        style: context.texts.bodyLarge_.copyWith(
                          color: context.colors.onSurfaceText,
                        ),
                      ),
                    );
                  }),
                ],
                onChanged: onChanged,
                isExpanded: true,
                underline: Container(),
                selectedItemBuilder: (context) {
                  return [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Выберите категорию',
                        style: context.texts.bodyLarge_.copyWith(
                          color: context.colors.onSurfaceText,
                        ),
                      ),
                    ),
                    ...categories.map((category) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          category.name,
                          style: context.texts.bodyLarge_.copyWith(
                            color: context.colors.onSurfaceText,
                          ),
                        ),
                      );
                    }),
                  ];
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

/// Раздел редактирования даты
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

/// Раздел редактирования комментария
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
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Комментарий',
          hintStyle: TextStyle(color: Colors.grey[400]),
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

/// Виджет-обертка для одинакового стиля всех разделов
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
