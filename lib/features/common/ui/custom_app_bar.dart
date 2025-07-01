import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/app/theme/app_colors_scheme.dart';
import 'package:yandex_school_homework/app/theme/texts_extension.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onNext;
  final List<Widget> children;
  final Icon? nextIcon;
  final Icon? backIcon;
  final double extraHeight;
  final bool showBackButton;
  final Color? color;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onNext,
    this.children = const [],
    this.nextIcon,
    this.backIcon,
    this.extraHeight = 0,
    this.showBackButton = false,
    this.color,
  });

  @override
  Size get preferredSize => Size.fromHeight(64 + extraHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? context.colors.financeGreen,
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
                    icon: backIcon ?? const Icon(Icons.arrow_back),
                    onPressed: () {
                      context.pop();
                    },
                  )
                else
                  const SizedBox(width: 48),
                Text(title, style: context.texts.titleLarge_),
                if (nextIcon != null)
                  IconButton(icon: nextIcon!, onPressed: onNext)
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
