// ignore_for_file: lines_longer_than_80_chars
import 'package:beakpeek/Model/bird.dart';
import 'package:beakpeek/View/Home/Searching/searchbar_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../bird_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group(
    'Search Container',
    () {
      testWidgets(
        'Fetch All Birds Function Test',
        (tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: SearchbarContainer(province: 'gauteng', helpContent: ''),
              ),
            ),
          );
          expect(find.byType(Column), findsAtLeast(1));
          expect(find.byType(FutureBuilder<List<Bird>>), findsAtLeast(1));
        },
      );

      testWidgets(
        'Fetch All Birds Function Test error',
        (tester) async {
          final client = MockClient();

          // Use Mockito to return an unsuccessful response when it calls the
          // provided http.Client.
          when(client.get(Uri.parse(
                  'http://10.0.2.2:5000/api/Bird/GetBirdsInProvince/gauteng')))
              .thenAnswer(
            (_) async => http.Response('', 400),
          );
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: SearchbarContainer(province: 'gauteng', helpContent: ''),
              ),
            ),
          );
          expect(find.byType(Column), findsAtLeast(1));
          expect(find.byType(FutureBuilder<List<Bird>>), findsAtLeast(1));
          expect(find.byType(CircularProgressIndicator), findsAtLeast(1));
          await tester.pumpAndSettle();
          expect(find.byType(CircularProgressIndicator), findsNothing);
          expect(find.byType(Center), findsAtLeast(1));
          expect(find.byType(Text), findsAtLeast(1));
        },
      );
    },
  );
}
