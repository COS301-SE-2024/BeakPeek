import 'package:beakpeek/View/Home/bird_quiz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:beakpeek/Model/bird.dart';

import 'bird_sheet_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group(
    'fetchBirds',
    () {
      test('returns a list of birds if the http call completes successfully',
          () async {
        final client = MockClient();
        when(client.get(Uri.parse('http://10.0.2.2:5000/api/Bird/')))
            .thenAnswer(
          (_) async => http.Response(
              '''[{ "bird": {"ref": 1, "common_group": "Heron", "common_species": "Black-headed Heron", "genus": "Ardea", "species": "melanocephala", "full_Protocol_RR": 10.0, "full_Protocol_Number": 1, "latest_FP": "2022-01-01T00:00:00Z"}, 
              "pentad": {"pentad_Allocation": "12345", "pentad_Longitude": 30.0, "pentad_Latitude": -25.0, 
              "province": {"id": 1, "name": "TestProvince"}, "total_Cards": 1},
               "jan": 1.0, "feb": 1.0, "mar": 1.0, "apr": 1.0, "may": 1.0, "jun": 1.0, "jul": 1.0, "aug": 1.0, "sep": 1.0, "oct": 1.0, "nov": 1.0, "dec": 1.0, 
               "total_Records": 12, "reportingRate": 10.0}]''', 200),
        );

        final birds = await fetchBirds(client);
        expect(birds, isA<List<Bird>>());
        expect(birds.first.commonSpecies, 'Black-headed Heron');
      });

      test(
        'throws an exception if the http call completes with an error',
        () async {
          final client = MockClient();
          when(
            client.get(
              Uri.parse('http://10.0.2.2:5000/api/Bird/'),
            ),
          ).thenAnswer(
            (_) async => http.Response('Not Found', 404),
          );

          expect(fetchBirds(client), throwsException);
        },
      );
    },
  );

  group('getImages', () {
    test('returns a list of image URLs if the http call completes successfully',
        () async {
      final client = MockClient();
      final bird = Bird(
        id: 1,
        pentad: Pentad(
          pentadAllocation: '12345',
          pentadLongitude: 30.0,
          pentadLatitude: -25.0,
          province: Province(id: 1, name: 'TestProvince'),
          totalCards: 1,
        ),
        commonGroup: 'Heron',
        commonSpecies: 'Black-headed Heron',
        genus: 'Ardea',
        species: 'melanocephala',
        fullProtocolRR: 10.0,
        fullProtocolNumber: 1,
        latestFP: '2022-01-01T00:00:00Z',
        jan: 1.0,
        feb: 1.0,
        mar: 1.0,
        apr: 1.0,
        may: 1.0,
        jun: 1.0,
        jul: 1.0,
        aug: 1.0,
        sep: 1.0,
        oct: 1.0,
        nov: 1.0,
        dec: 1.0,
        totalRecords: 12,
        reportingRate: 10.0,
      );

      when(client.get(Uri.parse(
              'http://10.0.2.2:5000/api/BirdInfo/Black-headed Heron Heron')))
          .thenAnswer((_) async => http.Response(
              '{"images": [{"url": "https://example.com/image1.jpg"}, {"url": "https://example.com/image2.jpg"}]}',
              200));

      final images = await getImages(client, bird);
      expect(images, isA<List<String>>());
      expect(images.length, 2);
      expect(images.first, 'https://example.com/image1.jpg');
    });

    test('throws an exception if the http call completes with an error',
        () async {
      final client = MockClient();
      final bird = Bird(
        id: 1,
        pentad: Pentad(
          pentadAllocation: '12345',
          pentadLongitude: 30.0,
          pentadLatitude: -25.0,
          province: Province(id: 1, name: 'TestProvince'),
          totalCards: 1,
        ),
        commonGroup: 'Heron',
        commonSpecies: 'Black-headed Heron',
        genus: 'Ardea',
        species: 'melanocephala',
        fullProtocolRR: 10.0,
        fullProtocolNumber: 1,
        latestFP: '2022-01-01T00:00:00Z',
        jan: 1.0,
        feb: 1.0,
        mar: 1.0,
        apr: 1.0,
        may: 1.0,
        jun: 1.0,
        jul: 1.0,
        aug: 1.0,
        sep: 1.0,
        oct: 1.0,
        nov: 1.0,
        dec: 1.0,
        totalRecords: 12,
        reportingRate: 10.0,
      );

      when(client.get(Uri.parse(
              'http://10.0.2.2:5000/api/BirdInfo/Black-headed Heron Heron')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(getImages(client, bird), throwsException);
    });
  });
}
