import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/app/theme/app_colors_scheme.dart';
import 'package:yandex_school_homework/app/theme/theme_notifier.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            _buildThemeSwitch(context),
            const SizedBox(height: 16),

          ],
        ),
      ),
    );
  }

  Widget _buildThemeSwitch(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        final isDarkForced = themeNotifier.themeMode == ThemeMode.dark;
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(
              isDarkForced ? Icons.dark_mode : Icons.light_mode,
              color: context.colors.financeGreen,
            ),
            title: Text(
              'Темная тема',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              isDarkForced ? 'Включена' : 'Системная',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: Switch.adaptive(
              value: isDarkForced,
              onChanged: (value) => themeNotifier.changeTheme(value),
              activeColor: context.colors.financeGreen,
            ),
          ),
        );
      },
    );
  }
}
