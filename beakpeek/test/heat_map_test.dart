import 'package:beakpeek/View/Map/heat_map.dart';
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
            id: 1,
          ),
        ),
      ),
    );

    // Verify that the widget renders without errors
    expect(find.byType(HeatMap), findsOneWidget);
  });

  group('HeatMapState', () {
    test('getColorForReportingRate returns correct colors', () {
      final heatMapState = HeatMapState();

      // Test reporting rate less than 40
      expect(
        heatMapState.getColorForReportingRate(30),
        equals(Colors.red.withOpacity(0.4)),
      );

      // Test reporting rate between 40 and 60
      expect(
        heatMapState.getColorForReportingRate(50),
        equals(Colors.orange.withOpacity(0.4)),
      );

      // Test reporting rate between 60 and 80
      expect(
        heatMapState.getColorForReportingRate(70),
        equals(Colors.yellow.withOpacity(0.4)),
      );

      // Test reporting rate greater than or equal to 80
      expect(
        heatMapState.getColorForReportingRate(90),
        equals(Colors.green.withOpacity(0.4)),
      );
    });

    test('getCameraPositionForProvince returns correct camera positions', () {
      final heatMapState = HeatMapState();

      // Test for gauteng
      expect(
        heatMapState.getCameraPositionForProvince('gauteng'),
        equals(const CameraPosition(
            target: LatLng(-25.7559141, 28.2330593), zoom: 8.0)),
      );

      // Test for westerncape
      expect(
        heatMapState.getCameraPositionForProvince('westerncape'),
        equals(
          const CameraPosition(target: LatLng(-33.9249, 18.4241), zoom: 8.0),
        ),
      );

      // Test for Eastern Cape
      expect(
        heatMapState.getCameraPositionForProvince('Eastern Cape'),
        equals(
          const CameraPosition(target: LatLng(-32.2968, 26.4194), zoom: 8.0),
        ),
      );

      // Test for an unknown province (default case)
      expect(
        heatMapState.getCameraPositionForProvince('unknown'),
        equals(const CameraPosition(
            target: LatLng(-25.7559141, 28.2330593), zoom: 8.0)),
      );
    });
  });
}
