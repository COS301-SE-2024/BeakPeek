import 'package:flutter_test/flutter_test.dart';
import 'package:beakpeek/Model/BirdInfo/pentad.dart';
import 'package:beakpeek/Model/BirdInfo/province.dart';

void main() {
  group('Pentad class unit tests', () {
    test('fromJson constructor with valid data', () {
      final pentadData = {
        'pentad_Allocation': '12345',
        'pentad_Longitude': 28.1234,
        'pentad_Latitude': -25.9876,
        'province': {
          'id': 1,
          'name': 'Gauteng',
          'birds': null // Assuming no birds for this test
        },
        'total_Cards': 100
      };

      final pentad = Pentad.fromJson(pentadData);

      // Test the values in Pentad
      expect(pentad.pentadAllocation, '12345');
      expect(pentad.pentadLongitude, 28.1234);
      expect(pentad.pentadLatitude, -25.9876);
      expect(pentad.totalCards, 100);

      // Test the Province data inside Pentad
      expect(pentad.province.id, 1);
      expect(pentad.province.name, 'Gauteng');
      expect(pentad.province.birds, null);
    });

    test('toMap method', () {
      final province = Province(
        id: 1,
        name: 'Gauteng',
      );

      final pentad = Pentad(
        pentadAllocation: '54321',
        pentadLongitude: 20.1234,
        pentadLatitude: -33.9876,
        province: province,
        totalCards: 50,
      );

      final pentadMap = pentad.toMap();

      // Check the map values
      expect(pentadMap['pentadAllocation'], '54321');
      expect(pentadMap['pentadLongitude'], 20.1234);
      expect(pentadMap['pentadLatitude'], -33.9876);
      expect(pentadMap['totalCards'], 50);

      // Check the nested province map
      final provinceMap = pentadMap['province'] as Map<String, dynamic>;
      expect(provinceMap['id'], 1);
      expect(provinceMap['name'], 'Gauteng');
      expect(provinceMap['birds'], null);
    });
  });
}
