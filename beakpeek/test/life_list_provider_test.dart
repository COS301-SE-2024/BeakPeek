import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:beakpeek/Model/bird_search_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:beakpeek/Model/bird.dart';

import 'life_list_provider_test.mocks.dart';

@GenerateMocks([LifeListProvider])
void main() {
  group('LifeListProvider Tests', () {
    test('getColorForReportingRate returns correct color index', () {
      expect(getColorForReportingRate(30), 0);
      expect(getColorForReportingRate(50), 1);
      expect(getColorForReportingRate(70), 2);
      expect(getColorForReportingRate(90), 3);
    });

    testWidgets('getData shows correct UI for bird', (tester) async {
      final bird = Bird(
        pentad: '123456',
        spp: 1,
        commonGroup: 'Sparrow',
        commonSpecies: 'House Sparrow',
        genus: 'Passer',
        species: 'domesticus',
        reportingRate: 55.0,
      );
      final mockLifeListProvider = MockLifeListProvider();

      when(mockLifeListProvider.isDuplicate(bird))
          .thenAnswer((_) async => false);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: getData(bird, mockLifeListProvider),
        ),
      ));

      expect(find.text('Sparrow House Sparrow'), findsOneWidget);
      expect(find.text('Scientific Name: Passer domesticus'), findsOneWidget);
      expect(find.text('55.0%'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Update the mock to return true for isDuplicate
      when(mockLifeListProvider.isDuplicate(bird))
          .thenAnswer((_) async => true);
      mockLifeListProvider.insertBird(bird);
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: getData(bird, mockLifeListProvider),
        ),
      ));

      expect(find.text('Seen'), findsNothing);
    });

    test('sortAlphabetically sorts birds by commonGroup', () {
      final birds = [
        Bird(
            pentad: '123456',
            spp: 1,
            commonGroup: 'Sparrow',
            commonSpecies: 'House Sparrow',
            genus: 'Passer',
            species: 'domesticus',
            reportingRate: 55.0),
        Bird(
            pentad: '123456',
            spp: 1,
            commonGroup: 'Finch',
            commonSpecies: 'House Finch',
            genus: 'Haemorhous',
            species: 'mexicanus',
            reportingRate: 65.0),
      ];

      final sortedBirds = sortAlphabetically(birds);

      expect(sortedBirds[0].commonGroup, 'Finch');
      expect(sortedBirds[1].commonGroup, 'Sparrow');
    });

    test('sortRepotRateDESC sorts birds by reportingRate in descending order',
        () {
      final birds = [
        Bird(
            pentad: '123456',
            spp: 1,
            commonGroup: 'Sparrow',
            commonSpecies: 'House Sparrow',
            genus: 'Passer',
            species: 'domesticus',
            reportingRate: 55.0),
        Bird(
            pentad: '123456',
            spp: 1,
            commonGroup: 'Finch',
            commonSpecies: 'House Finch',
            genus: 'Haemorhous',
            species: 'mexicanus',
            reportingRate: 65.0),
      ];

      final sortedBirds = sortRepotRateDESC(birds);

      expect(sortedBirds[0].reportingRate, 65.0);
      expect(sortedBirds[1].reportingRate, 55.0);
    });

    test('searchForBird returns correct birds based on search value', () {
      final birds = [
        Bird(
            pentad: '123456',
            spp: 1,
            commonGroup: 'Sparrow',
            commonSpecies: 'House Sparrow',
            genus: 'Passer',
            species: 'domesticus',
            reportingRate: 55.0),
        Bird(
            pentad: '123456',
            spp: 1,
            commonGroup: 'Finch',
            commonSpecies: 'House Finch',
            genus: 'Haemorhous',
            species: 'mexicanus',
            reportingRate: 65.0),
      ];

      final results = searchForBird(birds, 'sparrow');

      expect(results.length, 1);
      expect(results[0].commonSpecies, 'House Sparrow');
    });

    test('getUniqueBirds returns unique birds with highest reportingRate', () {
      final birds = [
        Bird(
            pentad: '123456',
            spp: 1,
            commonGroup: 'Sparrow',
            commonSpecies: 'House Sparrow',
            genus: 'Passer',
            species: 'domesticus',
            reportingRate: 55.0),
        Bird(
            pentad: '123456',
            spp: 1,
            commonGroup: 'Sparrow',
            commonSpecies: 'House Sparrow',
            genus: 'Passer',
            species: 'domesticus',
            reportingRate: 65.0),
        Bird(
            pentad: '123456',
            spp: 1,
            commonGroup: 'Finch',
            commonSpecies: 'House Finch',
            genus: 'Haemorhous',
            species: 'mexicanus',
            reportingRate: 60.0),
      ];

      final uniqueBirds = getUniqueBirds(birds);

      expect(uniqueBirds.length, 2);
      expect(uniqueBirds[0].reportingRate, 65.0);
      expect(uniqueBirds[1].reportingRate, 60.0);
    });
  });
}
