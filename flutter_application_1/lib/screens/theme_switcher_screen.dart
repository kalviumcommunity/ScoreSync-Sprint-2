// theme_switcher_screen.dart
// Assignment 3.46 – Creating Themed UIs Using Dark Mode and Dynamic Colors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ── Theme State (Provider) ──

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  void setTheme(ThemeMode mode) {
    _mode = mode;
    notifyListeners();
  }
}

// ── Custom Light & Dark Themes ──

final lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),
  useMaterial3: true,
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.teal,
    brightness: Brightness.dark,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.tealAccent,
  ),
  useMaterial3: true,
);

// ── Entry point: wraps screen in its own MaterialApp + Provider ──

class ThemeSwitcherScreen extends StatelessWidget {
  const ThemeSwitcherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Theme Switcher Center',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeNotifier.mode,
            home: const _ThemeSwitcherHome(),
          );
        },
      ),
    );
  }
}

// ── Main Screen ──

class _ThemeSwitcherHome extends StatelessWidget {
  const _ThemeSwitcherHome();

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Switcher Center'),
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Preview card ──
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Theme: ${isDark ? "Dark 🌙" : "Light ☀️"}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This card adapts to your selected theme. '
                      'Try switching between light, dark, and system below.',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              'Select Theme Mode',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // ── Radio tiles for each ThemeMode ──
            _ThemeOption(
              label: 'Light Mode ☀️',
              value: ThemeMode.light,
              groupValue: themeNotifier.mode,
              onChanged: (val) => themeNotifier.setTheme(val!),
            ),
            _ThemeOption(
              label: 'Dark Mode 🌙',
              value: ThemeMode.dark,
              groupValue: themeNotifier.mode,
              onChanged: (val) => themeNotifier.setTheme(val!),
            ),
            _ThemeOption(
              label: 'System / Dynamic 📱',
              value: ThemeMode.system,
              groupValue: themeNotifier.mode,
              onChanged: (val) => themeNotifier.setTheme(val!),
            ),

            const SizedBox(height: 30),

            // ── Quick toggle switch ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Quick Dark Toggle', style: TextStyle(fontSize: 16)),
                Switch(
                  value: themeNotifier.mode == ThemeMode.dark,
                  onChanged: (val) {
                    themeNotifier.setTheme(val ? ThemeMode.dark : ThemeMode.light);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable radio tile ──

class _ThemeOption extends StatelessWidget {
  final String label;
  final ThemeMode value;
  final ThemeMode groupValue;
  final ValueChanged<ThemeMode?> onChanged;

  const _ThemeOption({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<ThemeMode>(
      title: Text(label),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }
}
