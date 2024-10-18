import 'package:flutter_test/flutter_test.dart';
import 'package:beakpeek/Model/BirdInfo/pentad.dart';
import 'package:beakpeek/Model/BirdInfo/province.dart';

void main() {
  group('Pentad', () {
    test('fromJson should correctly parse JSON', () {
      final json = {
        'pentad_Allocation': 'some_allocation',
        'pentad_Longitude': 10.0,
        'pentad_Latitude': -20.0,
        'province': {'name': 'Gauteng', 'id': 1},
        'total_Cards': 5,
      };

      final pentad = Pentad.fromJson(json);
      expect(pentad.pentadAllocation, 'some_allocation');
      expect(pentad.pentadLongitude, 10.0);
      expect(pentad.pentadLatitude, -20.0);
      expect(pentad.totalCards, 5);
    });

    test('toMap should correctly serialize the object', () {
      final province =
          Province(name: 'Gauteng', id: 1); // Assume Province has a constructor
      final pentad = Pentad(
        pentadAllocation: 'some_allocation',
        pentadLongitude: 10.0,
        pentadLatitude: -20.0,
        province: province,
        totalCards: 5,
      );

      final map = pentad.toMap();
      expect(map['pentadAllocation'], 'some_allocation');
      expect(map['pentadLongitude'], 10.0);
      expect(map['totalCards'], 5);
    });
  });
}
