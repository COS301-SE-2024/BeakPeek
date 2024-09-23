// ignore_for_file: unused_import, unused_local_variable, lines_longer_than_80_chars

import 'package:beakpeek/Model/BirdInfo/pentad.dart';
import 'package:beakpeek/Model/BirdInfo/province.dart';
import 'package:beakpeek/Model/Sightings/sightings_functions.dart';
import 'package:beakpeek/Model/UserProfile/user_profile_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

import 'local_storage_test.mocks.dart';

@GenerateMocks([LocalStorage])
void main() {
  final province = Province(id: 1, name: 'Province A');
  final pentad = Pentad(
    pentadAllocation: 'Allocation A',
    pentadLongitude: 20.0,
    pentadLatitude: 30.0,
    province: province,
    totalCards: 50,
  );
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

    // test('changeThemeMode toggles theme and updates LocalStorage', () {
    //   when(mockLocalStorage.getItem('theme')).thenReturn('');
    //   final themeMode = changeThemeMode(mockLocalStorage);
    //   expect(themeMode, ThemeMode.dark);
    //   verify(mockLocalStorage.setItem('theme', 'dark')).called(1);

    //   when(mockLocalStorage.getItem('theme')).thenReturn('dark');
    //   final newThemeMode = changeThemeMode(mockLocalStorage);
    //   expect(newThemeMode, ThemeMode.light);
    //   verify(mockLocalStorage.setItem('theme', '')).called(1);
    // });

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
      id: 1,
      pentad: pentad,
      fullProtocolRR: 10.0,
      fullProtocolNumber: 5,
      latestFP: 'FP A',
      jan: 1.0,
      feb: 2.0,
      mar: 3.0,
      apr: 4.0,
      may: 5.0,
      jun: 6.0,
      jul: 7.0,
      aug: 8.0,
      sep: 9.0,
      oct: 10.0,
      nov: 11.0,
      dec: 12.0,
      totalRecords: 100,
      commonGroup: 'Sparrow',
      commonSpecies: 'House Sparrow',
      genus: 'Passer',
      species: 'domesticus',
      reportingRate: 55.0,
    );

    // testWidgets('getLiveList displays list of birds', (tester) async {
    //   final List<Bird> birds = [bird];
    //   void test(Bird temp) {}
    //   await tester.pumpWidget(MaterialApp(
    //     home: Scaffold(
    //       body: getLiveList(birds, test),
    //     ),
    //   ));

    //   expect(find.text('NO Birds Seen'), findsNothing);
    //   expect(find.text('Sparrow House Sparrow'), findsOneWidget);
    //   expect(find.text('Scientific Name: Passer domesticus'), findsOneWidget);
    // });

    // testWidgets('getLiveList displays "NO Birds Seen" when bird list is empty',
    //     (tester) async {
    //   final List<Bird> birds = [];
    //   void test(Bird temp) {}
    //   await tester.pumpWidget(MaterialApp(
    //     home: Scaffold(
    //       body: getLiveList(birds, test),
    //     ),
    //   ));

    //   expect(find.text('NO Birds Seen'), findsOneWidget);
    // });

    testWidgets('progressBars displays progress bars', (tester) async {
      final List<int> birdNums = [100, 200, 300, 400, 500, 600, 700, 800, 900];
      final List<int> birdNumK = [100, 200, 300, 400, 500, 600, 700, 800, 900];
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: progressBars(birdNums, birdNumK),
        ),
      ));

      expect(find.byType(FAProgressBar), findsAtLeast(4));
    });

    test('sortAlphabetically sorts birds correctly', () {
      final List<Bird> birds = [
        Bird(
          id: 1,
          pentad: pentad,
          fullProtocolRR: 10.0,
          fullProtocolNumber: 5,
          latestFP: 'FP A',
          jan: 1.0,
          feb: 2.0,
          mar: 3.0,
          apr: 4.0,
          may: 5.0,
          jun: 6.0,
          jul: 7.0,
          aug: 8.0,
          sep: 9.0,
          oct: 10.0,
          nov: 11.0,
          dec: 12.0,
          totalRecords: 100,
          commonGroup: 'Finch',
          commonSpecies: 'Zebra Finch',
          genus: 'Taeniopygia',
          species: 'guttata',
          reportingRate: 30.0,
        ),
      ];

      final sortedBirds = sortAlphabetically(birds);
      expect(sortedBirds.first.commonGroup, 'Finch');
      expect(sortedBirds.last.commonSpecies, 'Zebra Finch');
    });

    test('getPercent calculates percentage correctly', () {
      expect(getPercent(1000, 500), 50.0);
      expect(getPercent(1000, 750), 75.0);
    });
  });

  group('Level Progress Functions', () {
    test('getNextLevelExpRequired calculates correctly', () {
      expect(getNextLevelExpRequired(1), 125);
      expect(getNextLevelExpRequired(2), 200);
      expect(getNextLevelExpRequired(3), 325);
    });

    test('progressPercentage calculates correctly', () {
      expect(progressPercentage(100, 1), 80);
      expect(progressPercentage(120, 1), 96);
      expect(progressPercentage(200, 2), 100);
    });
  });

  group('Widget Tests', () {
    testWidgets('levelProgressBar displays progress correctly', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: levelProgressBar(50, 1),
        ),
      ));

      expect(find.byType(FAProgressBar), findsOneWidget);
      // Add more specific checks based on your FAProgressBar widget
    });
  });
}
