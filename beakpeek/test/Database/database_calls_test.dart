import 'package:beakpeek/Controller/DB/database_calls.dart';
import 'package:beakpeek/Model/bird.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../bird_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group(
    'Database controller Tests',
    () {
      test(
        'Featch All Birds Function Test',
        () async {
          final client = MockClient();

          when(client.get(Uri.parse(
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

          expect(await fetchAllBirds(client), isA<List<Bird>>());
        },
      );

      test(
        'throws an exception if the http call completes with an error',
        () {
          final client = MockClient();

          // Use Mockito to return an unsuccessful response when it calls the
          // provided http.Client.
          when(client.get(Uri.parse(
                  'http://10.0.2.2:5000/api/Bird/GetBirdsInProvince/gauteng')))
              .thenAnswer((_) async => http.Response('Not Found', 404));

          expect(fetchAllBirds(client), throwsException);
        },
      );
    },
  );
}
