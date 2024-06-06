import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:beakpeek/bird.dart';
// class MockClient extends Mock implements http.Client {}

import 'bird_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('Bird', () {
    test('fromJson creates a Bird from JSON', () {
      final json = {
        'pentad': 'Test Pentad',
        'spp': 1,
        'common_group': 'Test Common Group',
        'common_species': 'Test Common Species',
        'genus': 'Test Genus',
        'species': 'Test Species',
        'reportingRate': 1.0,
      };

      final bird = Bird.fromJson(json);

      expect(bird.pentad, 'Test Pentad');
      expect(bird.spp, 1);
      expect(bird.commonGroup, 'Test Common Group');
      expect(bird.commonSpecies, 'Test Common Species');
      expect(bird.genus, 'Test Genus');
      expect(bird.species, 'Test Species');
      expect(bird.reportingRate, 1.0);
    });
  });

  group('fetchBirds', () {
    test('returns a List of Bird if the http call completes successfully',
        () async {
      final client = MockClient();
      const pentadId = 'testId';

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse(
              'http://10.0.2.2:5000/api/GautengBirdSpecies/$pentadId/pentad')))
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

      expect(await fetchBirds(pentadId, client), isA<List<Bird>>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();
      const pentadId = 'testId';

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse(
              'http://10.0.2.2:5000/api/GautengBirdSpecies/$pentadId/pentad')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(fetchBirds(pentadId, client), throwsException);
    });
  });
}
