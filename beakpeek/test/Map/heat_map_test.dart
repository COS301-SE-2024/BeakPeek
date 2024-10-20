import 'package:beakpeek/Model/Globals/globals.dart';
import 'package:beakpeek/View/Map/heat_map.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HeatMap', () {
    // ignore: unused_local_variable
    late HeatMap heatMap;
    late HeatMapState heatMapState;
    setUp(() {
      heatMap = const HeatMap(id: 1);
      heatMapState = HeatMapState(); // Pass required parameters
    });

    test('getColorForReportingRate returns correct colors', () {
      expect(heatMapState.getColorForReportingRate(10),
          equals(global.palette.low.withOpacity(0.8)));
      expect(heatMapState.getColorForReportingRate(30),
          equals(global.palette.mediumLow.withOpacity(0.8)));
      expect(heatMapState.getColorForReportingRate(50),
          equals(global.palette.medium.withOpacity(0.8)));
      expect(heatMapState.getColorForReportingRate(70),
          equals(global.palette.mediumHigh.withOpacity(0.8)));
      expect(heatMapState.getColorForReportingRate(85),
          equals(global.palette.high.withOpacity(0.8)));
      expect(heatMapState.getColorForReportingRate(95),
          equals(global.palette.veryHigh.withOpacity(0.8)));
    });

    test('calculateCoordinatesFromPentad converts correctly', () {
      final coordinates =
          heatMapState.calculateCoordinatesFromPentad('1234', '5678');
      expect(coordinates.latitude,
          equals(-57.3)); // Adjust this based on expected output
      expect(coordinates.longitude,
          equals(12.566666666666666)); // Adjust this based on expected output
    });
  });
}
