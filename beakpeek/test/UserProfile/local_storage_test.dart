import 'package:beakpeek/Model/user_profile_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:localstorage/localstorage.dart';
// Adjust the import as per your file structure

// Mock class for LocalStorage
class MockLocalStorage extends Mock implements LocalStorage {}

void main() {
  late MockLocalStorage mockLocalStorage;

  setUp(() {
    mockLocalStorage = MockLocalStorage();
  });
  group('changeThemeMode', () {
    test('sets theme to dark when there is no theme set', () async {
      when(mockLocalStorage.getItem('theme')).thenReturn('');
      when(mockLocalStorage.setItem('theme', 'dark'))
          .thenAnswer((_) async => true);

      expect(changeThemeMode(mockLocalStorage), ThemeMode.dark);
      verify(mockLocalStorage.setItem('theme', 'dark')).called(1);
    });

    test('sets theme to light when the theme is set to dark', () async {
      when(mockLocalStorage.getItem('theme')).thenReturn('dark');
      when(mockLocalStorage.setItem('theme', '')).thenAnswer((_) async => true);

      expect(changeThemeMode(mockLocalStorage), ThemeMode.light);
      verify(mockLocalStorage.setItem('theme', '')).called(1);
    });
  });

  group('getIcon', () {
    test('returns dark mode icon when theme is not set', () async {
      when(mockLocalStorage.getItem('theme')).thenReturn('');

      expect(
          (getIcon(mockLocalStorage) as Icon).icon, Icons.dark_mode_outlined);
    });

    test('returns light mode icon when theme is set to dark', () async {
      when(mockLocalStorage.getItem('theme')).thenReturn('dark');

      expect(
          (getIcon(mockLocalStorage) as Icon).icon, Icons.light_mode_outlined);
    });
  });

  group('getLabelIcon', () {
    test('returns "Dark Mode" when theme is not set', () async {
      when(mockLocalStorage.getItem('theme')).thenReturn('');

      expect(getLabelIcon(mockLocalStorage), 'Dark Mode');
    });

    test('returns "Light Mode" when theme is set to dark', () async {
      when(mockLocalStorage.getItem('theme')).thenReturn('dark');

      expect(getLabelIcon(mockLocalStorage), 'Light Mode');
    });
  });
}
