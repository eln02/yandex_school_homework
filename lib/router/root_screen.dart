import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/app/theme/app_colors_scheme.dart';
import 'package:yandex_school_homework/features/connectivity_checker/connectivity_status_bar.dart';
import 'package:yandex_school_homework/gen/assets.gen.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final icons = [
      Assets.icons.expenses,
      Assets.icons.income,
      Assets.icons.accounts,
      Assets.icons.items,
      Assets.icons.settings,
    ];
    final labels = ['Расходы', 'Доходы', 'Счета', 'Статьи', 'Настройки'];

    return Scaffold(
      body: Column(
        children: [
          Expanded(child: navigationShell),
          const ConnectivityStatusBar(),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: navigationShell.currentIndex,
          onTap: navigationShell.goBranch,
          backgroundColor: context.colors.surfaceContainer_,
          selectedItemColor: context.colors.onSurface_,
          unselectedItemColor: context.colors.onSurface_,
          showUnselectedLabels: true,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          // TODO(me): Вынести стили текста в контекст
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600, // semibold
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500, // medium
          ),
          items: List.generate(5, (index) {
            final isSelected = index == navigationShell.currentIndex;

            return BottomNavigationBarItem(
              icon: Container(
                width: 64,
                height: 32,
                decoration: isSelected
                    ? BoxDecoration(
                        color: context.secondaryColor,
                        borderRadius: BorderRadius.circular(32),
                      )
                    : null,
                alignment: Alignment.center,
                child: icons[index].svg(
                  colorFilter: ColorFilter.mode(
                    isSelected
                        ? context.primaryColor
                        : context.colors.onSurface_,
                    BlendMode.srcIn,
                  ),
                  width: 24,
                  height: 24,
                ),
              ),
              label: labels[index],
            );
          }),
        ),
      ),
    );
  }
}
