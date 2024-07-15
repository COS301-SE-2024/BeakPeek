import 'package:beakpeek/Controller/Main/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:beakpeek/Styles/theme_colors.dart';

void main() {
  group('ThemeProvider', () {
    late ThemeProvider themeProvider;

    setUp(() {
      themeProvider = ThemeProvider();
    });

    test('Initial theme mode should be ThemeMode.system', () {
      expect(themeProvider.themeMode, ThemeMode.system);
    });

    test('Set theme mode should update themeMode and notify listeners', () {
      bool notified = false;
      themeProvider.addListener(() {
        notified = true;
      });

      themeProvider.setThemeMode(ThemeMode.dark);

      expect(themeProvider.themeMode, ThemeMode.dark);
      expect(notified, true);
    });

    test('Initial dark scheme should be darkColorScheme', () {
      expect(themeProvider.darkScheme, darkColorScheme);
    });

    test('Set dark scheme should update darkScheme and notify listeners', () {
      bool notified = false;
      themeProvider.addListener(() {
        notified = true;
      });

      const newDarkScheme = ColorScheme.dark(
        primary: Colors.blue,
        secondary: Colors.red,
      );
      themeProvider.setDarkScheme(newDarkScheme);

      expect(themeProvider.darkScheme, newDarkScheme);
      expect(notified, true);
    });

    test('Initial light scheme should be lightColorScheme', () {
      expect(themeProvider.lightScheme, lightColorScheme);
    });

    test('Set light scheme should update lightScheme and notify listeners', () {
      bool notified = false;
      themeProvider.addListener(() {
        notified = true;
      });

      const newLightScheme = ColorScheme.light(
        primary: Colors.green,
        secondary: Colors.yellow,
      );
      themeProvider.setLightScheme(newLightScheme);

      expect(themeProvider.lightScheme, newLightScheme);
      expect(notified, true);
    });
  });
}
