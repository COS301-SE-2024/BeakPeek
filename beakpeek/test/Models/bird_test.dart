import 'package:beakpeek/Model/BirdInfo/province.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Model/BirdInfo/pentad.dart';

void main() {
  group('Bird', () {
    test('fromJson should correctly parse JSON', () {
      final json = {
        'bird': {
          'ref': 1,
          'pentad': {
            'pentad_Allocation': 'some_allocation',
            'pentad_Longitude': 10.0,
            'pentad_Latitude': -20.0,
            'province': {'name': 'Gauteng', 'id': 1},
            'total_Cards': 5,
          },
          'common_group': 'Test Group',
          'common_species': 'Test Species',
          'genus': 'Test Genus',
          'species': 'Test Species',
          'full_Protocol_RR': 1.0,
          'full_Protocol_Number': 10,
          'latest_FP': 'Test Latest',
          'jan': 0.1,
          'total_Records': 100,
          'reportingRate': 0.5,
          'info': 'Some info',
          'image_Url': 'http://example.com/image.png',
          'provinces': ['gauteng', 'kwazulunatal']
        },
        'total_Records': 100
      };

      final bird = Bird.fromJson(json);
      expect(bird.id, 1);
      expect(bird.commonGroup, 'Test Group');
      expect(bird.pentad?.pentadAllocation, 'some_allocation');
      expect(bird.totalRecords, 100);
    });

    test('toMap should correctly serialize the object', () {
      final bird = Bird(
        id: 1,
        pentad: Pentad(
          pentadAllocation: 'some_allocation',
          pentadLongitude: 10.0,
          pentadLatitude: -20.0,
          province: Province(
              name: 'Gauteng', id: 1), // Assume Province has a constructor
          totalCards: 5,
        ),
        commonGroup: 'Test Group',
        commonSpecies: 'Test Species',
        genus: 'Test Genus',
        species: 'Test Species',
        fullProtocolRR: 1.0,
        fullProtocolNumber: 10,
        latestFP: 'Test Latest',
        jan: 0.1,
        totalRecords: 100,
        reportingRate: 0.5,
        info: 'Some info',
        imageUrl: 'http://example.com/image.png',
        provinces: ['gauteng', 'kwazulunatal'],
      );

      final map = bird.toMap();
      expect(map['id'], 1);
      expect(map['commonGroup'], 'Test Group');
      expect(map['totalRecords'], 100);
      final pentad = map['pentad'] as Map<String, dynamic>?;

      expect(pentad?['pentadAllocation'], 'some_allocation');
    });
  });
}
