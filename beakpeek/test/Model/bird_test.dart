import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Model/BirdInfo/pentad.dart';
import 'package:beakpeek/Model/BirdInfo/province.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Bird', () {
    test('fromJson should correctly parse valid JSON', () {
      final json = {
        'bird': {
          'ref': 1,
          'common_group': 'Group A',
          'common_species': 'Species A',
          'genus': 'Genus A',
          'species': 'Species A',
          'full_Protocol_RR': 10.0,
          'full_Protocol_Number': 5,
          'latest_FP': 'FP A'
        },
        'pentad': {
          'pentad_Allocation': 'Allocation A',
          'pentad_Longitude': 20.0,
          'pentad_Latitude': 30.0,
          'province': {
            'id': 1,
            'name': 'Province A',
            'birds': null,
          },
          'total_Cards': 50
        },
        'jan': 1.0,
        'feb': 2.0,
        'mar': 3.0,
        'apr': 4.0,
        'may': 5.0,
        'jun': 6.0,
        'jul': 7.0,
        'aug': 8.0,
        'sep': 9.0,
        'oct': 10.0,
        'nov': 11.0,
        'dec': 12.0,
        'total_Records': 100,
        'reportingRate': 50.0
      };

      final bird = Bird.fromJson(json);

      expect(bird.id, 1);
      expect(bird.commonGroup, 'Group A');
      expect(bird.commonSpecies, 'Species A');
      expect(bird.genus, 'Genus A');
      expect(bird.species, 'Species A');
      expect(bird.fullProtocolRR, 10.0);
      expect(bird.fullProtocolNumber, 5);
      expect(bird.latestFP, 'FP A');
      expect(bird.jan, 1.0);
      expect(bird.feb, 2.0);
      expect(bird.mar, 3.0);
      expect(bird.apr, 4.0);
      expect(bird.may, 5.0);
      expect(bird.jun, 6.0);
      expect(bird.jul, 7.0);
      expect(bird.aug, 8.0);
      expect(bird.sep, 9.0);
      expect(bird.oct, 10.0);
      expect(bird.nov, 11.0);
      expect(bird.dec, 12.0);
      expect(bird.totalRecords, 100);
      expect(bird.reportingRate, 50.0);
    });

    test('toMap should correctly convert Bird to map', () {
      final province = Province(id: 1, name: 'Province A');
      final pentad = Pentad(
        pentadAllocation: 'Allocation A',
        pentadLongitude: 20.0,
        pentadLatitude: 30.0,
        province: province,
        totalCards: 50,
      );

      final bird = Bird(
        id: 1,
        pentad: pentad,
        commonGroup: 'Group A',
        commonSpecies: 'Species A',
        genus: 'Genus A',
        species: 'Species A',
        fullProtocolRR: 10.0,
        fullProtocolNumber: 5,
        latestFP: 'FP A',
        jan: 1.0,
        feb: 2.0,
        mar: 3.0,
        apr: 4.0,
        may: 5.0,
        jun: 6.0,
        jul: 7.0,
        aug: 8.0,
        sep: 9.0,
        oct: 10.0,
        nov: 11.0,
        dec: 12.0,
        totalRecords: 100,
        reportingRate: 50.0,
      );

      final map = bird.toMap();

      expect(map['id'], 1);
      expect(map['commonGroup'], 'Group A');
      expect(map['commonSpecies'], 'Species A');
      expect(map['genus'], 'Genus A');
      expect(map['species'], 'Species A');
      expect(map['fullProtocolRR'], 10.0);
      expect(map['fullProtocolNumber'], 5);
      expect(map['latestFP'], 'FP A');
      expect(map['jan'], 1.0);
      expect(map['feb'], 2.0);
      expect(map['mar'], 3.0);
      expect(map['apr'], 4.0);
      expect(map['may'], 5.0);
      expect(map['jun'], 6.0);
      expect(map['jul'], 7.0);
      expect(map['aug'], 8.0);
      expect(map['sep'], 9.0);
      expect(map['oct'], 10.0);
      expect(map['nov'], 11.0);
      expect(map['dec'], 12.0);
      expect(map['totalRecords'], 100);
      expect(map['reportingRate'], 50.0);
    });
  });

  group('Pentad', () {
    test('fromJson should correctly parse valid JSON', () {
      final json = {
        'pentad_Allocation': 'Allocation A',
        'pentad_Longitude': 20.0,
        'pentad_Latitude': 30.0,
        'province': {
          'id': 1,
          'name': 'Province A',
          'birds': null,
        },
        'total_Cards': 50
      };

      final pentad = Pentad.fromJson(json);

      expect(pentad.pentadAllocation, 'Allocation A');
      expect(pentad.pentadLongitude, 20.0);
      expect(pentad.pentadLatitude, 30.0);
      expect(pentad.totalCards, 50);
    });

    test('toMap should correctly convert Pentad to map', () {
      final province = Province(id: 1, name: 'Province A');
      final pentad = Pentad(
        pentadAllocation: 'Allocation A',
        pentadLongitude: 20.0,
        pentadLatitude: 30.0,
        province: province,
        totalCards: 50,
      );

      final map = pentad.toMap();

      expect(map['pentadAllocation'], 'Allocation A');
      expect(map['pentadLongitude'], 20.0);
      expect(map['pentadLatitude'], 30.0);
      expect(map['totalCards'], 50);
    });
  });

  group('Province', () {
    test('fromJson should correctly parse valid JSON', () {
      final json = {
        'id': 1,
        'name': 'Province A',
        'birds': null,
      };

      final province = Province.fromJson(json);

      expect(province.id, 1);
      expect(province.name, 'Province A');
    });

    test('toMap should correctly convert Province to map', () {
      final province = Province(id: 1, name: 'Province A');

      final map = province.toMap();

      expect(map['id'], 1);
      expect(map['name'], 'Province A');
    });
  });
}
