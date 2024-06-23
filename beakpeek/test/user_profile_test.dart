import 'package:beakpeek/Model/user_profile_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'filterable_searchbar_test.dart';

void change() {}
void main() {
  group(
    'User Functions',
    () {
      test(
        'getThemeMode',
        () {
          expect(getThemeMode(''), ThemeMode.light);
          expect(getThemeMode('darh'), ThemeMode.dark);
        },
      );

      test(
        'Birds List',
        () {
          expect(birdL.length, 2);
          expect(birdL[0].pentad, '1');
          expect(birdL[0].spp, 1);
          expect(birdL[1].commonGroup, 'commonGroup');
          expect(birdL[1].commonSpecies, 'commonSpecies');
          expect(birdL[1].genus, 'genus');
          expect(birdL[0].species, 'species');
          expect(birdL[0].reportingRate, 10.0);
        },
      );

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
