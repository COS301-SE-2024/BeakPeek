import 'dart:convert';

import 'package:beakpeek/Controller/DB/database_calls.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import 'database_calls_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('Bird API Tests', () {
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
    });

    test('fetchAllBirds returns unique birds on success', () async {
      when(
        mockClient.get(
          Uri.parse(
              'https://beakpeekbirdapi.azurewebsites.net/api/Bird/GetBirdsInProvince/gauteng'),
        ),
      ).thenAnswer((_) async {
        final jsonResponse = [
          {
            'bird': {
              'ref': 1,
              'common_group': 'Group A',
              'common_species': 'Species A',
              'genus': 'Genus A',
              'species': 'Species A',
              'full_Protocol_RR': 10.0,
              'full_Protocol_Number': 5,
              'latest_FP': 'FP A',
            },
            'pentad': {
              'pentad_Allocation': 'Allocation A',
              'pentad_Longitude': 20.0,
              'pentad_Latitude': 30.0,
              'province': {'id': 1, 'name': 'Province A'},
              'total_Cards': 50,
            },
            'jan': 1.0,
            'feb': 2.0,
            'mar': 3.0,
            'apr': 4.0,
            'may': 5.0,
            'jun': 6.0,
            'jul': 7.0,
            'aug': 8.0,
            'sep': 9.0,
            'oct': 10.0,
            'nov': 11.0,
            'dec': 12.0,
            'total_Records': 100,
            'reportingRate': 50.0,
          },
        ];
        return http.Response(jsonEncode(jsonResponse), 200);
      });

      final List<Bird> birds = await fetchAllBirds('gauteng', mockClient);

      expect(birds.length, 1);
      expect(birds[0].commonSpecies, 'Species A');
    });

    test('fetchAllBirds throws an exception on non-200 response', () async {
      when(mockClient.get(Uri.parse(
              'https://beakpeekbirdapi.azurewebsites.net/api/Bird/GetBirdsInProvince/gauteng')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(fetchAllBirds('gauteng', mockClient), throwsException);
    });
  });
}
