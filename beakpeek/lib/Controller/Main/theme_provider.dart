import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  final ColorScheme lightScheme = const ColorScheme.light(
    primary: Color(0xFF033A30),
    secondary: Color(0xFFECAD31),
    // Add other colors as needed
  );

  final ColorScheme darkScheme = const ColorScheme.dark(
    primary: Color(0xFF1A1A1A), // Dark grey background
    secondary: Color(0xFFECAD31),
    // Add other colors as needed
  );

  void setInitialTheme(String theme) {
    _themeMode = theme.isEmpty ? ThemeMode.light : ThemeMode.dark;
  }

  void toggleTheme(bool isDarkMode) {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    localStorage.setItem('theme', isDarkMode ? 'dark' : '');
    notifyListeners();
  }
}
