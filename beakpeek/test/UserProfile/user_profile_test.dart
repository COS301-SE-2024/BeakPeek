import 'package:beakpeek/Model/bird.dart';
import 'package:beakpeek/Model/user_profile_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final birdL = [
  Bird(
    pentad: '1',
    spp: 1,
    commonGroup: 'here',
    commonSpecies: 'here',
    genus: 'genus',
    species: 'species',
    reportingRate: 20.0,
  ),
  Bird(
    pentad: '1',
    spp: 1,
    commonGroup: 'commonGroup',
    commonSpecies: 'commonSpecies',
    genus: 'genus',
    species: 'species',
    reportingRate: 10.0,
  ),
];
void main() {
  group(
    'User profile tests',
    () {
      testWidgets(
        'getLiveList',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: getLiveList(),
              ),
            ),
          );

          expect(find.byType(Column), findsAtLeast(1));
          expect(find.byType(ListTile), findsAtLeast(2));
        },
      );
    },
  );
}
