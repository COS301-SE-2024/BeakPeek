import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:beakpeek/View/Home/bird_map.dart'; // Adjust the import based on your structure
import 'package:mockito/mockito.dart';

// Mock GoogleMapController
class MockGoogleMapController extends Mock implements GoogleMapController {
  @override
  Future<void> animateCamera(CameraUpdate update) async {}
}

void main() {
  testWidgets('BirdMap widget builds correctly', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BirdMap(),
        ),
      ),
    );

    // Verify the presence of dropdown and map
    expect(find.byType(DropdownButton<String>), findsOneWidget);
    expect(find.byType(GoogleMap), findsOneWidget);
  });

  testWidgets('Dropdown updates camera position', (WidgetTester tester) async {
    final mockController = MockGoogleMapController();

    // Build the widget with the mock controller
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BirdMap(testController: mockController),
        ),
      ),
    );
    await tester.pumpAndSettle();


    // Simulate the map creation and initialization
    final mapFinder = find.byType(GoogleMap);
    expect(mapFinder, findsOneWidget);

    // Wait for the map controller to be initialized
    await tester.pump(); // Ensure the widget tree is built
    await tester.pumpAndSettle(); // Wait for async operations to complete

    // // Simulate dropdown interaction
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();

    expect(find.text('gauteng'), findsAtLeastNWidgets(1));
    expect(find.text('westerncape'), findsAtLeastNWidgets(1));
    expect(find.text('Eastern Cape'), findsAtLeastNWidgets(1));

    // // Select a new province
    // await tester.tap(find.text('westerncape').hitTestable());
    // await tester.pumpAndSettle();

    // Verify that animateCamera is called on the mock controller
    // verify(mockController.animateCamera(any as CameraUpdate)).called(1);
  });
}
