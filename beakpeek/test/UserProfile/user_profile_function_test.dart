import 'package:beakpeek/Model/user_profile_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:beakpeek/Model/bird.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

import 'local_storage_test.mocks.dart';

void main() {
  group('Theme Mode Tests', () {
    late MockLocalStorage mockLocalStorage;

    setUp(() {
      mockLocalStorage = MockLocalStorage();
    });

    test('getThemeMode returns ThemeMode.light when data is empty', () {
      expect(getThemeMode(''), ThemeMode.light);
    });

    test('getThemeMode returns ThemeMode.dark when data is not empty', () {
      expect(getThemeMode('dark'), ThemeMode.dark);
    });

    test('changeThemeMode toggles theme and updates LocalStorage', () {
      when(mockLocalStorage.getItem('theme')).thenReturn('');
      final themeMode = changeThemeMode(mockLocalStorage);
      expect(themeMode, ThemeMode.dark);
      verify(mockLocalStorage.setItem('theme', 'dark')).called(1);

      when(mockLocalStorage.getItem('theme')).thenReturn('dark');
      final newThemeMode = changeThemeMode(mockLocalStorage);
      expect(newThemeMode, ThemeMode.light);
      verify(mockLocalStorage.setItem('theme', '')).called(1);
    });

    test('getIcon returns correct icon based on theme', () {
      when(mockLocalStorage.getItem('theme')).thenReturn('');
      final iconLight = getIcon(mockLocalStorage);
      expect(
        iconLight,
        isA<Icon>()
            .having((icon) => icon.icon, 'icon', Icons.dark_mode_outlined),
      );

      when(mockLocalStorage.getItem('theme')).thenReturn('dark');
      final iconDark = getIcon(mockLocalStorage);
      expect(
        iconDark,
        isA<Icon>()
            .having((icon) => icon.icon, 'icon', Icons.light_mode_outlined),
      );
    });

    test('getLabelIcon returns correct label based on theme', () {
      when(mockLocalStorage.getItem('theme')).thenReturn('');
      expect(getLabelIcon(mockLocalStorage), 'Dark Mode');

      when(mockLocalStorage.getItem('theme')).thenReturn('dark');
      expect(getLabelIcon(mockLocalStorage), 'Light Mode');
    });
  });

  group('Bird List Tests', () {
    final bird = Bird(
      pentad: '12345',
      spp: 1,
      commonGroup: 'Sparrow',
      commonSpecies: 'House Sparrow',
      genus: 'Passer',
      species: 'domesticus',
      reportingRate: 55.0,
    );

    testWidgets('getLiveList displays list of birds', (tester) async {
      final List<Bird> birds = [bird];
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: getLiveList(birds),
        ),
      ));

      expect(find.text('NO Birds Seen'), findsNothing);
      expect(find.text('Sparrow House Sparrow'), findsOneWidget);
      expect(find.text('Scientific Name: Passer domesticus'), findsOneWidget);
    });

    testWidgets('getLiveList displays "NO Birds Seen" when bird list is empty',
        (tester) async {
      final List<Bird> birds = [];
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: getLiveList(birds),
        ),
      ));

      expect(find.text('NO Birds Seen'), findsOneWidget);
    });

    testWidgets('progressBars displays progress bars', (tester) async {
      final List<int> birdNums = [100, 200, 300, 400, 500, 600, 700, 800, 900];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: progressBars(birdNums),
        ),
      ));

      expect(find.byType(FAProgressBar), findsAtLeast(4));
    });

    test('sortAlphabetically sorts birds correctly', () {
      final List<Bird> birds = [
        Bird(
          pentad: '12345',
          spp: 2,
          commonGroup: 'Finch',
          commonSpecies: 'Zebra Finch',
          genus: 'Taeniopygia',
          species: 'guttata',
          reportingRate: 30.0,
        ),
        bird
      ];

      final sortedBirds = sortAlphabetically(birds);
      expect(sortedBirds.first.commonGroup, 'Finch');
      expect(sortedBirds.last.commonGroup, 'Sparrow');
    });

    test('getPercent calculates percentage correctly', () {
      expect(getPercent(500, 1000), 200.0);
      //expect(getPercent(750, 1000), 250.0);
    });
  });
}
