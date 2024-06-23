import 'package:beakpeek/View/Home/heat_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';

class MockGoogleMapController extends Mock implements GoogleMapController {}

void main() {
  testWidgets('HeatMap widget renders', (tester) async {
    // Build our widget and trigger a frame
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HeatMap(
            commonGroup: 'Dove',
            commonSpecies: 'Laughing',
          ),
        ),
      ),
    );

    // Verify that the widget renders without errors
    expect(find.byType(HeatMap), findsOneWidget);
  });
}
