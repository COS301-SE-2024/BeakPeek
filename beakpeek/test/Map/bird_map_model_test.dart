// ignore_for_file: lines_longer_than_80_chars, unused_import

import 'package:beakpeek/Model/bird_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../bird_sheet_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('KmlParser', () {
    test('parseKml should parse KML string correctly', () {
      const kmlString = '''
        <kml>
          <Document>
            <Placemark>
              <name>TestId</name>
              <Polygon>
                <outerBoundaryIs>
                  <LinearRing>
                    <coordinates>
                      -122.0822035425683,37.42228990140251,0 
                      -122.084075,37.422000,0 
                      -122.0822035425683,37.42228990140251,0
                    </coordinates>
                  </LinearRing>
                </outerBoundaryIs>
              </Polygon>
            </Placemark>
          </Document>
        </kml>
      ''';

      final result = KmlParser.parseKml(kmlString);

      expect(result, [
        {
          'id': 'TestId',
          'coordinates': [
            {'latitude': 37.42228990140251, 'longitude': -122.0822035425683},
            {'latitude': 37.422000, 'longitude': -122.084075},
            {'latitude': 37.42228990140251, 'longitude': -122.0822035425683},
          ],
        },
      ]);
    });
  });

  group('BirdMapFunctions', () {
    
  });
}
