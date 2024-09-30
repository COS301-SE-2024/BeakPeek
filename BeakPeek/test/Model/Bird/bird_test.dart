import 'package:flutter_test/flutter_test.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart'; // Import your Bird class file

void main() {
  group('Bird class unit tests', () {
    test('fromJson constructor with valid data', () {
      final birdData = {
        'bird': {
          'ref': 123,
          'common_group': 'Songbirds',
          'common_species': 'Common Sparrow',
          'genus': 'Passer',
          'species': 'domesticus',
          'full_Protocol_RR': 10.5,
          'full_Protocol_Number': 5,
          'latest_FP': '2024-09-01',
          'jan': 1.1,
          'feb': 2.2,
          'mar': 3.3,
          'apr': 4.4,
          'may': 5.5,
          'jun': 6.6,
          'jul': 7.7,
          'aug': 8.8,
          'sep': 9.9,
          'oct': 10.0,
          'nov': 11.1,
          'dec': 12.2,
          'total_Records': 20,
          'reportingRate': 5.0,
          'info': 'Test bird info',
          'image_Url': 'https://example.com/image.jpg',
          'provinces': ['gauteng', 'limpopo']
        }
      };

      final bird = Bird.fromJson(birdData);

      expect(bird.id, 123);
      expect(bird.commonGroup, 'Songbirds');
      expect(bird.commonSpecies, 'Common Sparrow');
      expect(bird.genus, 'Passer');
      expect(bird.species, 'domesticus');
      expect(bird.fullProtocolRR, 10.5);
      expect(bird.fullProtocolNumber, 5);
      expect(bird.latestFP, '2024-09-01');
      expect(bird.jan, 0.0);
      expect(bird.feb, 0.0);
      expect(bird.totalRecords, 20);
      expect(bird.reportingRate, 5.0);
      expect(bird.imageUrl, 'https://example.com/image.jpg');
      expect(bird.provinces, containsAll([]));
    });

    test('fromJsonLife constructor with valid data', () {
      final birdData = {
        'bird': {
          'id': 456,
          'common_group': 'Raptors',
          'common_species': 'Eagle',
          'genus': 'Aquila',
          'species': 'chrysaetos',
          'full_Protocol_RR': 15.2,
          'total_Records': 30,
          'reportingRate': 8.3
        }
      };

      final bird = Bird.fromJsonLife(birdData);

      expect(bird.id, 456);
      expect(bird.commonGroup, 'Raptors');
      expect(bird.commonSpecies, 'Eagle');
      expect(bird.genus, 'Aquila');
      expect(bird.species, 'chrysaetos');
      expect(bird.fullProtocolRR, 15.2);
      expect(bird.totalRecords, 30);
      expect(bird.reportingRate, 8.3);
    });

    test('toMap method', () {
      final bird = Bird(
          id: 789,
          commonGroup: 'Waterfowl',
          commonSpecies: 'Duck',
          genus: 'Anas',
          species: 'platyrhynchos',
          fullProtocolRR: 12.5,
          fullProtocolNumber: 8,
          latestFP: '2024-10-01',
          jan: 2.0,
          feb: 3.0,
          mar: 4.0,
          apr: 5.0,
          may: 6.0,
          jun: 7.0,
          jul: 8.0,
          aug: 9.0,
          sep: 10.0,
          oct: 11.0,
          nov: 12.0,
          dec: 13.0,
          totalRecords: 50,
          reportingRate: 9.5,
          info: 'Duck species',
          imageUrl: 'https://example.com/duck.jpg',
          provinces: ['gauteng', 'westerncape'],
          population: 100);

      final map = bird.toMap();

      expect(map['id'], 789);
      expect(map['commonGroup'], 'Waterfowl');
      expect(map['commonSpecies'], 'Duck');
      expect(map['genus'], 'Anas');
      expect(map['species'], 'platyrhynchos');
      expect(map['fullProtocolRR'], 12.5);
      expect(map['totalRecords'], 50);
      expect(map['reportingRate'], 9.5);
    });
  });
}
