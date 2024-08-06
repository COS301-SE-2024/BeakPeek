import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:beakpeek/Model/bird.dart';
import 'package:beakpeek/View/Home/bird_quiz.dart';

import 'bird_sheet_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('fetchBirds', () {
    test('returns a list of birds if the http call completes successfully', () async {
      final client = MockClient();

      // Use Mockito to return a successful response when it calls the provided http.Client.
      when(client.get(Uri.parse('http://10.0.2.2:5000/api/Bird/')))
          .thenAnswer((_) async => http.Response(
              '[{"common_species": "Black-headed Heron", "common_group": "Heron", "reportingRate": 10}]', 200));

      expect(await fetchBirds(client), isA<List<Bird>>());
    });

    test('throws an exception if the http call completes with an error', () async {
      final client = MockClient();
      when(client.get(Uri.parse('http://10.0.2.2:5000/api/Bird/')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(fetchBirds(client), throwsException);
    });
  });

  group('getImages', () {
    test(
      'returns a list of image URLs if the http call completes successfully',
       () async {
      final client = MockClient();
      final bird = Bird(commonSpecies: 'Black-headed Heron', 
                        commonGroup: 'Heron', 
                        reportingRate: 10.0, 
                        species: '', 
                        pentad: '', 
                        spp:0, 
                        genus: ''
                      );

      when(client.get(Uri.parse('http://10.0.2.2:5000/api/BirdInfo/Black-headed Heron Heron')))
          .thenAnswer((_) async => http.Response(
              '{"images": [{"url": "https://example.com/image1.jpg"}, {"url": "https://example.com/image2.jpg"}]}',
              200));

      expect(await getImages(client, bird), isA<List<String>>());
    });

    test('throws an exception if the http call completes with an error', () async {
      final client = MockClient();
      final bird = Bird(commonSpecies: 'Black-headed Heron', commonGroup: 'Heron', reportingRate: 10.0, species: '', pentad: '', spp:0, genus: '');

      when(client.get(Uri.parse('http://10.0.2.2:5000/api/BirdInfo/Black-headed Heron Heron')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(getImages(client, bird), throwsException);
    });
  });
}
