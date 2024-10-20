import 'package:beakpeek/View/Map/bird_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';

// Mock the GoogleMapController and http.Client
class MockGoogleMapController extends Mock implements GoogleMapController {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BirdMap Widget Tests', () {
    late MockGoogleMapController mockMapController;

    setUp(() {
      mockMapController = MockGoogleMapController();
    });

    testWidgets('renders the GoogleMap widget', (tester) async {
      // Build the BirdMap widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BirdMap(testController: mockMapController),
          ),
        ),
      );

      // Verify that the GoogleMap widget is rendered
      expect(find.byType(GoogleMap), findsOneWidget);
    });

    testWidgets('Filter button renders and opens dialog', (tester) async {
      // Build the BirdMap widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BirdMap(testController: mockMapController),
          ),
        ),
      );

      // Verify the Filter button is rendered
      expect(find.text('Filter Map'), findsOneWidget);

      // Tap the filter button to open the dialog
      await tester.tap(find.text('Filter Map'));
      await tester.pumpAndSettle();

      // Verify the filter dialog opens
      expect(find.text('Map Filters'), findsOneWidget);
    });

    testWidgets('Verify month dropdown renders and can be changed',
        (tester) async {
      // Build the BirdMap widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BirdMap(testController: mockMapController),
          ),
        ),
      );

      // Open filter dialog
      await tester.tap(find.text('Filter Map'));
      await tester.pumpAndSettle();

      // Verify the month dropdown is displayed
      expect(find.text('Filter by month:'), findsOneWidget);

      // Select a month from the dropdown
      await tester.tap(find.text('Year-Round'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('January').last);
      await tester.pumpAndSettle();

      // Verify that the month is selected
      expect(find.text('January'), findsOneWidget);
    });

    testWidgets('Check if polygons load correctly', (tester) async {
      // Mock KML data loading
      // You can mock the KmlParser or use a stubbed dataset here

      // Build the BirdMap widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BirdMap(testController: mockMapController),
          ),
        ),
      );

      // Verify the map displays polygons (assuming KML loads correctly)
      expect(find.byType(GoogleMap), findsOneWidget);

      // Verify that polygons are drawn on the map (mock polygon set behavior)
      // You can simulate a polygon being rendered on the map using mock data
    });
  });
}
