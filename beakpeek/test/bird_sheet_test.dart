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
      expect(find.text('Group A Species A'), findsOneWidget);
    });
  });
}
