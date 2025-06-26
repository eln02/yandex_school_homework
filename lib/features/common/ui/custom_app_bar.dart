import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/app/theme/app_colors_scheme.dart';
import 'package:yandex_school_homework/app/theme/texts_extension.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onNext;
  final List<Widget> children;
  final Icon? icon;
  final double extraHeight;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onNext,
    this.children = const [],
    this.icon,
    this.extraHeight = 0,
    this.showBackButton = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(64 + extraHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.financeGreen,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Column(
        children: [
          SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (showBackButton)
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  )
                else
                  const SizedBox(width: 48),
                Text(title, style: context.texts.titleLarge_),
                if (icon != null)
                  IconButton(icon: icon!, onPressed: onNext)
                else
                  const SizedBox(width: 48),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}
