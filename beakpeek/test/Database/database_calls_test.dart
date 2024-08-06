import 'package:beakpeek/Controller/DB/database_calls.dart';
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
      when(mockClient.get(Uri.parse(
              'http://10.0.2.2:5000/api/Bird/GetBirdsInProvince/gauteng')))
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

      final birds = await fetchAllBirds('gauteng', mockClient);

      expect(birds.length, 1);
      expect(birds[0].commonSpecies, 'Test Common Species');
    });

    test('fetchAllBirds throws an exception on non-200 response', () async {
      when(mockClient.get(Uri.parse(
              'http://10.0.2.2:5000/api/Bird/GetBirdsInProvince/gauteng')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(fetchAllBirds('gauteng', mockClient), throwsException);
    });

    test('getNumberOfBirdsInProvinces returns numbers on success', () async {
      when(mockClient.get(any))
          .thenAnswer((_) async => http.Response('10', 200));

      final numbers = await getNumberOfBirdsInProvinces(mockClient);

      expect(numbers.length, provinces.length);
      expect(numbers, List.generate(provinces.length, (index) => 10));
    });

    test('getNumberOfBirdsInProvinces throws an exception on non-200 response',
        () async {
      when(mockClient.get(any))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(getNumberOfBirdsInProvinces(mockClient), throwsException);
    });
  });
}
