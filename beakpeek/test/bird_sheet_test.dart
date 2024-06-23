import 'package:beakpeek/Model/bird.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:beakpeek/View/Home/bird_sheet.dart';

import 'bird_sheet_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('ResizableBottomSheet Widget Test', () {
    testWidgets('Test initial state - Error response', (tester) async {
      // Mock http client
      final mockClient = MockClient();
      const pentadId = 'testId';

      // Provide mock response for fetchBirds
      when(mockClient.get(Uri.parse(
              'http://10.0.2.2:5000/api/GautengBirdSpecies/$pentadId/pentad')))
          .thenAnswer((_) async => http.Response('Error', 400));

      // Build our widget and trigger a frame.
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: BirdSheet(pentadId: pentadId),
        ),
      ));

      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.text('Birds in this area'), findsOneWidget);
      // expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the widget to rebuild after future resolves
      await tester.pumpAndSettle();

      // Verify error message is displayed
      expect(find.text('No birds found.'), findsOneWidget);

      // Verify that no BirdList widget is found
      expect(find.byType(BirdList), findsNothing);
    });

    testWidgets('Test initial state - Successful response', (tester) async {
      // Define your JSON response
      final List<Map<String, dynamic>> jsonResponse = [
        {
          'pentad': 'Test Pentad',
          'spp': 1,
          'common_group': 'Test Common Group',
          'common_species': 'Test Common Species',
          'genus': 'Test Genus',
          'species': 'Test Species',
          'reportingRate': 1.0,

        }
      ];

      // Map the JSON response to a list of Bird objects
      final List<Bird> birds =
          jsonResponse.map((json) => Bird.fromJson(json)).toList();

      // Pump the BirdList widget into the test environment
      await tester.pumpWidget(MaterialApp(
        home: BirdList(
          birds: birds,
        ),
      ));

      // debugDumpApp();

      // Verify the widget's initial state
      expect(
          find.text('Test Common Group Test Common Species'), findsOneWidget);
    });

  });
}
