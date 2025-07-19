import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/app/theme/theme_notifier.dart';
import 'package:yandex_school_homework/router/app_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Color _currentPickerColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentPickerColor = context.theme.primaryColor;
  }

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
            ElevatedButton(
              onPressed: () => context.pushNamed(AppRouter.pinSettings),
              child: Text('Экран настроек пина'),
            ),
            _buildThemeSwitch(context),
            const SizedBox(height: 16),
            _buildColorPicker(context),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPicker(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(Icons.palette, color: context.primaryColor),
            title: const Text('Основной цвет'),
            trailing: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: themeNotifier.primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black12),
              ),
            ),
            onTap: () => _showColorPicker(context, themeNotifier),
          ),
        );
      },
    );
  }

  void _showColorPicker(BuildContext context, ThemeNotifier themeNotifier) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Выберите основной цвет'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _currentPickerColor,
              onColorChanged: (color) {
                setState(() {
                  _currentPickerColor = color;
                });
              },
              pickerAreaHeightPercent: 0.8,
              enableAlpha: false,
              displayThumbColor: true,
              labelTypes: const [],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                themeNotifier.changePrimaryColor(_currentPickerColor);
                Navigator.pop(context);
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
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
              color: context.primaryColor,
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
              activeColor: context.primaryColor,
            ),
          ),
        );
      },
    );
  }
}
