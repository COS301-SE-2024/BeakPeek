import 'dart:convert';

import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:beakpeek/View/Map/bird_sheet.dart';

import 'bird_sheet_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('Bird Model', () {
    test('Bird.fromJson creates a Bird object from JSON', () {
      final jsonMap = {
        'ref': 1,
        'common_group': 'Group A',
        'common_species': 'Species A',
        'genus': 'Genus A',
        'species': 'Species A',
        'full_Protocol_RR': 60.5,
        'full_Protocol_Number': 10,
        'latest_FP': 'Latest FP',
        'jan': 10.0,
        'feb': 20.0,
        'mar': 30.0,
        'apr': 40.0,
        'may': 50.0,
        'jun': 60.0,
        'jul': 70.0,
        'aug': 80.0,
        'sep': 90.0,
        'oct': 100.0,
        'nov': 110.0,
        'dec': 120.0,
        'total_Records': 200,
        'reportingRate': 70.5
      };

      final bird = Bird.fromJson(jsonMap);
      expect(bird.id, 1);
      expect(bird.commonGroup, 'Group A');
      expect(bird.commonSpecies, 'Species A');
      expect(bird.genus, 'Genus A');
      expect(bird.species, 'Species A');
      expect(bird.reportingRate, 70.5);
    });

    test('Bird.toMap converts a Bird object to a map', () {
      final bird = Bird(
        id: 1,
        commonGroup: 'Group A',
        commonSpecies: 'Species A',
        genus: 'Genus A',
        species: 'Species A',
        fullProtocolRR: 60.5,
        fullProtocolNumber: 10,
        latestFP: 'Latest FP',
        jan: 10.0,
        feb: 20.0,
        mar: 30.0,
        apr: 40.0,
        may: 50.0,
        jun: 60.0,
        jul: 70.0,
        aug: 80.0,
        sep: 90.0,
        oct: 100.0,
        nov: 110.0,
        dec: 120.0,
        totalRecords: 200,
        reportingRate: 70.5,
      );

      final map = bird.toMap();
      expect(map['id'], 1);
      expect(map['commonGroup'], 'Group A');
      expect(map['reportingRate'], 70.5);
    });
  });

  group('fetchBirds', () {
    test('returns a list of birds if the http call completes successfully',
        () async {
      final client = MockClient();

      // Mock the response to return a successful status with sample data
      when(client.get(Uri.parse(
              'https://beakpeekbirdapi.azurewebsites.net/api/Bird/123/pentad')))
          .thenAnswer((_) async => http.Response(
              jsonEncode([
                {
                  'ref': 1,
                  'common_group': 'Group A',
                  'common_species': 'Species A',
                  'genus': 'Genus A',
                  'species': 'Species A',
                  'full_Protocol_RR': 60.5,
                  'full_Protocol_Number': 10,
                  'latest_FP': 'Latest FP',
                  'jan': 10.0,
                  'feb': 20.0,
                  'mar': 30.0,
                  'apr': 40.0,
                  'may': 50.0,
                  'jun': 60.0,
                  'jul': 70.0,
                  'aug': 80.0,
                  'sep': 90.0,
                  'oct': 100.0,
                  'nov': 110.0,
                  'dec': 120.0,
                  'total_Records': 200,
                  'reportingRate': 70.5
                }
              ]),
              200));

      final birds = await fetchBirds('123', client);

      expect(birds, isA<List<Bird>>());
      expect(birds.length, 1);
      expect(birds[0].id, 1);
      expect(birds[0].commonGroup, 'Group A');
    });

    test('throws an exception if the http call completes with an error',
        () async {
      final client = MockClient();

      // Mock the response to return an error status
      when(client.get(Uri.parse(
              'https://beakpeekbirdapi.azurewebsites.net/api/Bird/123/pentad')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(fetchBirds('123', client), throwsException);
    });
  });
}
