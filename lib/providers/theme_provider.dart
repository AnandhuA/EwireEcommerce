import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  bool isDarkMode(BuildContext context) {
    if (_themeMode == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) ==
          Brightness.dark;
    }

    return _themeMode == ThemeMode.dark;
  }

  void toggleTheme(BuildContext context) {
    final isDark = isDarkMode(context);

    _themeMode =
        isDark ? ThemeMode.light : ThemeMode.dark;

    notifyListeners();
  }
}