import 'package:beakpeek/Model/bird.dart';
import 'package:beakpeek/Model/bird_search_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'bird_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group(
    'Bird Search Functions Test',
    () {
      test(
        'Featch All Birds Function Test',
        () async {
          final client = MockClient();

          when(client.get(
                  Uri.parse('http://10.0.2.2:5000/api/GautengBirdSpecies')))
              .thenAnswer((_) async => http.Response('''
          [
            {
              "pentad": "Test Pentad",
              "spp": 1,
              "common_group": "Test Common Group",
              "common_species": "Test Common Species",
              "genus": "Test Genus",
              "species": "Test Species",
              "reportingRate": 1.0
            }
          ]
          ''', 200));

          expect(await fetchAllBirds(client), isA<List<Bird>>());
        },
      );

      test(
        'getColorRepert Rate',
        () {
          final rate = getColorForReportingRate(20.0);
          expect(rate, 0);
        },
      );

      testWidgets(
        'Test getData ',
        (tester) async {
          final bird = Bird(
            pentad: '1',
            spp: 1,
            commonGroup: 'commonGroup',
            commonSpecies: 'commonSpecies',
            genus: 'genus',
            species: 'species',
            reportingRate: 10.0,
          );
          final Widget testW = getData(bird);
          await tester.pumpWidget(MaterialApp(
            home: Scaffold(
              body: ListView(
                children: [
                  testW,
                ],
              ),
            ),
          ));
          expect(find.byType(ListTile), findsOneWidget);
        },
      );

      test(
        'Bird search Function',
        () {
          final birds = [
            Bird(
              pentad: '1',
              spp: 1,
              commonGroup: 'commonGroup',
              commonSpecies: 'commonSpecies',
              genus: 'genus',
              species: 'species',
              reportingRate: 10.0,
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

          final search = searchForBird(birds, 'common');
          expect(search, birds);
        },
      );

      test(
        'Unique Birds Functions',
        () {
          final birds = [
            Bird(
              pentad: '1',
              spp: 1,
              commonGroup: 'commonGroup',
              commonSpecies: 'commonSpecies',
              genus: 'genus',
              species: 'species',
              reportingRate: 10.0,
            ),
            Bird(
              pentad: '1',
              spp: 1,
              commonGroup: 'commonGroup',
              commonSpecies: 'commonSpecies',
              genus: 'genus',
              species: 'species',
              reportingRate: 20.0,
            ),
          ];

          final uniqueBirds = getUniqueBirds(birds);
          expect(uniqueBirds.length, 1);
          expect(uniqueBirds[0].reportingRate, 20.0);
        },
      );
    },
  );
}

// final birds = [
//   Bird(
//     pentad: '1',
//     spp: 1,
//     commonGroup: 'commonGroup',
//     commonSpecies: 'commonSpecies',
//     genus: 'genus',
//     species: 'species',
//     reportingRate: 10.0,
//   ),
//   Bird(
//     pentad: '1',
//     spp: 1,
//     commonGroup: 'commonGroup',
//     commonSpecies: 'commonSpecies',
//     genus: 'genus',
//     species: 'species',
//     reportingRate: 10.0,
//   ),
// ];