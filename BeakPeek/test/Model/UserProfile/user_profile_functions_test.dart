// ignore_for_file: unused_local_variable

import 'package:beakpeek/Model/UserProfile/user_profile_function.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';

// Mock User Model
class MockUserModel {
  int xp = 0;
  int level = 1;
}

// Initialize a global user variable for testing
final MockUserModel user = MockUserModel();

void main() {
  group('Testing Utility Functions', () {
    test('getPercent returns correct percentage', () {
      expect(getPercent(100, 50), 50);
      expect(getPercent(0, 50), 1); // Test for zero total birds
    });

    test('sortAlphabetically sorts birds correctly', () {
      final birds = [
        Bird(
            id: 789,
            commonGroup: 'A',
            commonSpecies: 'Cuck',
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
            population: 100),
        Bird(
            id: 789,
            commonGroup: 'B',
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
            population: 100),
      ];
      final sortedBirds = sortAlphabetically(birds);
      expect(sortedBirds[0].commonGroup, 'A');
      expect(sortedBirds[1].commonGroup, 'B');
    });

    test('getNextLevelExpRequired returns correct values', () {
      expect(getNextLevelExpRequired(1), isNonNegative);
      expect(getNextLevelExpRequired(5), isNonNegative);
      expect(getNextLevelExpRequired(10), isNonNegative);
    });

    test('progressPercentage returns correct percentage', () {
      user.xp = 50; // set initial XP for testing
      final nextLevel = getNextLevelExpRequired(user.level);
      expect(progressPercentage(user.xp, user.level), lessThan(100));
    });

    test('birdexpByRarity calculates correctly for edge cases', () {
      expect(birdexpByRarity(0), 100);
      expect(birdexpByRarity(100), 1);
    });

    test('formatProvinceName formats the name correctly', () {
      expect(formatProvinceName('easterncape'), 'Easterncape');
      expect(formatProvinceName('kwazulunatal'), 'Kwazulunatal');
      expect(formatProvinceName('gauteng'), 'Gauteng');
    });
  });
}
