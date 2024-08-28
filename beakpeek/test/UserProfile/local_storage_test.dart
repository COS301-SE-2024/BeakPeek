// ignore_for_file: unused_local_variable, lines_longer_than_80_chars

import 'package:beakpeek/Model/BirdInfo/pentad.dart';
import 'package:beakpeek/Model/BirdInfo/province.dart';
import 'package:beakpeek/Model/UserProfile/user_profile_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:localstorage/localstorage.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';

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
  group('Theme Tests', () {
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
      commonGroup: 'Group A',
      commonSpecies: 'Species A',
      genus: 'Genus A',
      species: 'Species A',
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
      reportingRate: 50.0,
    );

    // testWidgets('getLiveList displays list of birds', (tester) async {
    //   BuildContext context;
    //   void test(Bird temp) {}
    //   final List<Bird> birds = [bird];
    //   await tester.pumpWidget(MaterialApp(
    //     home: Scaffold(
    //       body: getLiveList(birds, test, context),
    //     ),
    //   ));

    //   expect(find.text('NO Birds Seen'), findsNothing);
    //   expect(find.text('Group A Species A'), findsOneWidget);
    //   =expect(find.text('Scientific Name: Genus A Species A'), findsOneWidget);
    // });

    // testWidgets('getLiveList displays "NO Birds Seen" when bird list is empty',
    //     (tester) async {
    //   void test(Bird temp) {}
    //   final List<Bird> birds = [];
    //   await tester.pumpWidget(MaterialApp(
    //     home: Scaffold(
    //       body: getLiveList(birds, test),
    //     ),
    //   ));

    //   expect(find.text('NO Birds Seen'), findsOneWidget);
    // });
  });
}
