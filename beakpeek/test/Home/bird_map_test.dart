// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_test/flutter_test.dart';
import 'package:beakpeek/Model/bird.dart';
import 'package:beakpeek/Model/bird_map.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

// Mock class for http.Client
class MockClient extends Mock implements http.Client {}

void main() {
  group('KmlParser', () {
    test('parseKml correctly parses KML string', () {
      const kmlString = '''
      <kml>
        <Placemark>
          <name>1</name>
          <Polygon>
            <outerBoundaryIs>
              <LinearRing>
                <coordinates>
                  28.2330593,-25.7559141,0 28.2340593,-25.7569141,0
                </coordinates>
              </LinearRing>
            </outerBoundaryIs>
          </Polygon>
        </Placemark>
      </kml>
      ''';

      final result = KmlParser.parseKml(kmlString);

      expect(result, isNotEmpty);
      expect(result.first['id'], '1');
      expect(result.first['coordinates'], isNotEmpty);
      expect(result.first['coordinates'].first['latitude'], -25.7559141);
      expect(result.first['coordinates'].first['longitude'], 28.2330593);
    });

    test('parseKml handles empty KML string', () {
      const kmlString = '<kml></kml>';
      final result = KmlParser.parseKml(kmlString);

      expect(result, isEmpty);
    });
  });
}
