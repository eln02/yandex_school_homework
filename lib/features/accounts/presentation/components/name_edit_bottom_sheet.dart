import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/app/theme/app_colors_scheme.dart';
import 'package:yandex_school_homework/app/theme/texts_extension.dart';
import 'package:yandex_school_homework/features/accounts/domain/entity/account_entity.dart';
import 'package:yandex_school_homework/features/accounts/domain/state/account_cubit.dart';

/// Модальное окно для редактирования названия счета
void showNameEditBottomSheet(BuildContext context, AccountEntity account) {
  final controller = TextEditingController(text: account.name);

  final inputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: context.colors.onSurfaceText),
  );

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.colors.mainBackground,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ).copyWith(bottom: 20),
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
            TextField(
              controller: controller,
              style: context.texts.bodyLarge_.copyWith(
                color: context.colors.onSurfaceText,
              ),
              onEditingComplete: () {
                context.read<AccountCubit>().updateAccount(
                  name: controller.text,
                );
                context.pop();
              },
              maxLength: 100,
              decoration: InputDecoration(
                hintText: 'Название счета',
                hintStyle: context.texts.bodyLarge_.copyWith(
                  color: context.colors.onSurfaceText,
                ),
                border: inputBorder,
                enabledBorder: inputBorder,
                focusedBorder: inputBorder,
                errorBorder: inputBorder,
                focusedErrorBorder: inputBorder,
              ),
              autofocus: true,
            ),
          ],
        ),
      );
    },
  );
}
