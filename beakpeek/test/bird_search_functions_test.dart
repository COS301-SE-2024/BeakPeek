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

      test('throws an exception if the http call completes with an error', () {
        final client = MockClient();

        // Use Mockito to return an unsuccessful response when it calls the
        // provided http.Client.
        when(client
                .get(Uri.parse('http://10.0.2.2:5000/api/GautengBirdSpecies')))
            .thenAnswer((_) async => http.Response('Not Found', 404));

        expect(fetchAllBirds(client), throwsException);
      });

      test(
        'getColorRepert Rate',
        () {
          expect(getColorForReportingRate(20.0), 0);
          expect(getColorForReportingRate(40.0), 1);
          expect(getColorForReportingRate(60.0), 2);
          expect(getColorForReportingRate(80.0), 3);
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

      testWidgets(
        'Test getData ',
        (tester) async {
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
          final testW = getWidgetListOfBirds(birds);
          await tester.pumpWidget(MaterialApp(
            home: Scaffold(
              body: ListView(
                children: testW,
              ),
            ),
          ));
          expect(find.byType(ListTile), findsAtLeast(2));
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
        'Sort alphabetical ',
        () {
          final birds = [
            Bird(
              pentad: '1',
              spp: 1,
              commonGroup: 'BcommonGroup',
              commonSpecies: 'commonSpecies',
              genus: 'genus',
              species: 'species',
              reportingRate: 10.0,
            ),
            Bird(
              pentad: '1',
              spp: 1,
              commonGroup: 'AcommonGroup',
              commonSpecies: 'commonSpecies',
              genus: 'genus',
              species: 'species',
              reportingRate: 20.0,
            ),
          ];

          final sortedList = sortAlphabetically(birds);
          expect(sortedList.length, 2);
          expect(sortedList[0].commonGroup, 'AcommonGroup');
          expect(sortedList[1].commonGroup, 'BcommonGroup');
        },
      );

      test(
        'Sort Report Rate ',
        () {
          final birds = [
            Bird(
              pentad: '1',
              spp: 1,
              commonGroup: 'BcommonGroup',
              commonSpecies: 'commonSpecies',
              genus: 'genus',
              species: 'species',
              reportingRate: 10.0,
            ),
            Bird(
              pentad: '1',
              spp: 1,
              commonGroup: 'AcommonGroup',
              commonSpecies: 'commonSpecies',
              genus: 'genus',
              species: 'species',
              reportingRate: 20.0,
            ),
          ];

          final sortedList = sortRepotRateDESC(birds);
          expect(sortedList.length, 2);
          expect(sortedList[0].commonGroup, 'AcommonGroup');
          expect(sortedList[1].commonGroup, 'BcommonGroup');
          expect(sortedList[1].reportingRate, 10.0);
          expect(sortedList[0].reportingRate, 20.0);
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
