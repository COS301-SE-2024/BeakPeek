import 'package:beakpeek/Model/bird.dart';
import 'package:beakpeek/Model/user_profile_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final birds = [
  Bird(
    pentad: '1',
    spp: 1,
    commonGroup: 'Laughing',
    commonSpecies: 'Dove',
    genus: 'genus',
    species: 'species',
    reportingRate: 10.0,
  ),
  Bird(
    pentad: '1',
    spp: 1,
    commonGroup: 'African',
    commonSpecies: 'Eagle',
    genus: 'genus',
    species: 'species',
    reportingRate: 10.0,
  ),
];

void main() {
  group(
    'ThemeMode tests',
    () {
      test(
        'getThemeMode returns ThemeMode.light when data is empty',
        () {
          expect(getThemeMode(''), ThemeMode.light);
        },
      );

      test(
        'getThemeMode returns ThemeMode.dark when data is not empty',
        () {
          expect(getThemeMode('data'), ThemeMode.dark);
        },
      );
    },
  );

  group('Live List tests', () {
    testWidgets('getLiveList returns correct list of bird widgets',
        (tester) async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: getLiveList())));

      expect(find.text('Laughing Dove'), findsOneWidget);
      expect(find.text('African Eagle'), findsOneWidget);
    });
  });
}
