import 'package:flutter/material.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/app/theme/app_colors_scheme.dart';
import 'package:yandex_school_homework/app/theme/texts_extension.dart';

/// Базовый виджет для элементов настроек
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.leading,
    required this.title,
    this.trailing,
    this.onTap,
  });

  final Widget leading;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 65,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: context.colors.transactionsDivider,
            ),
          ),
        ),
        child: Row(
          children: [
            IconTheme(
              data: IconThemeData(color: context.colors.primary),
              child: leading,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: context.texts.bodyLarge_.copyWith(
                  color: context.colors.onSurfaceText,
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
