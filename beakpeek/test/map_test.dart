import 'package:beakpeek/View/Home/bird_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';


class MockGoogleMapController extends Mock implements GoogleMapController {}

void main() {
  testWidgets('BirdMap widget renders', (WidgetTester tester) async {
    // Build our widget and trigger a frame
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BirdMap(),
        ),
      ),
    );

    // Verify that the widget renders without errors
    expect(find.byType(BirdMap), findsOneWidget);
  });
}
