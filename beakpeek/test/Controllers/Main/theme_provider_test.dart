import 'package:beakpeek/Controller/Main/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localstorage/localstorage.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();

  group('ThemeProvider Tests', () {
    late ThemeProvider themeProvider;

    setUp(() {
      themeProvider = ThemeProvider();
    });

    test('Initial theme mode is system', () {
      expect(themeProvider.themeMode, ThemeMode.system);
    });

    test('setInitialTheme sets light theme when input is empty', () {
      themeProvider.setInitialTheme('');
      expect(themeProvider.themeMode, ThemeMode.light);
    });

    test('setInitialTheme sets dark theme when input is not empty', () {
      themeProvider.setInitialTheme('someTheme');
      expect(themeProvider.themeMode, ThemeMode.dark);
    });

    test('toggleTheme sets dark theme and updates local storage', () {
      // Set the localStorage in the ThemeProvider
      themeProvider.toggleTheme(true);
      expect(themeProvider.themeMode, ThemeMode.dark);
      expect(localStorage.getItem('theme'), 'dark');
    });

    test('toggleTheme sets light theme and updates local storage', () {
      themeProvider.toggleTheme(false);
      expect(themeProvider.themeMode, ThemeMode.light);
      expect(localStorage.getItem('theme'), '');
    });

    test('notifyListeners is called when toggling theme', () {
      bool listenerCalled = false;
      themeProvider.addListener(() {
        listenerCalled = true;
      });

      themeProvider.toggleTheme(true);
      expect(listenerCalled, true);
    });
  });
}
