import 'package:beakpeek/Controller/Main/color_palette_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ColorPalette Tests', () {
    test('greenRedPalette should have correct colors', () {
      expect(greenRedPalette.low, const Color.fromARGB(255, 255, 115, 105));
      expect(greenRedPalette.mediumLow, Colors.red);
      expect(greenRedPalette.medium, Colors.orange);
      expect(greenRedPalette.mediumHigh, Colors.yellow);
      expect(greenRedPalette.high, const Color.fromARGB(255, 103, 255, 108));
      expect(greenRedPalette.veryHigh, const Color.fromARGB(255, 1, 201, 34));
    });

    test('bluePurplePalette should have correct colors', () {
      expect(bluePurplePalette.low, const Color.fromARGB(255, 135, 206, 235));
      expect(bluePurplePalette.mediumLow, Colors.blue);
      expect(bluePurplePalette.medium, Colors.indigo);
      expect(bluePurplePalette.mediumHigh, Colors.purple);
      expect(bluePurplePalette.high, const Color.fromARGB(255, 186, 85, 211));
      expect(
          bluePurplePalette.veryHigh, const Color.fromARGB(255, 138, 43, 226));
    });

    test('earthyPalette should have correct colors', () {
      expect(earthyPalette.low, const Color.fromARGB(255, 210, 180, 140));
      expect(earthyPalette.mediumLow, const Color.fromARGB(255, 139, 69, 19));
      expect(earthyPalette.medium, const Color.fromARGB(255, 160, 82, 45));
      expect(
          earthyPalette.mediumHigh, const Color.fromARGB(255, 113, 153, 113));
      expect(earthyPalette.high, const Color.fromARGB(255, 60, 179, 113));
      expect(earthyPalette.veryHigh, const Color.fromARGB(255, 0, 128, 0));
    });

    test('sunsetPalette should have correct colors', () {
      expect(sunsetPalette.low, const Color.fromARGB(255, 255, 228, 196));
      expect(sunsetPalette.mediumLow, const Color.fromARGB(255, 255, 140, 0));
      expect(sunsetPalette.medium, const Color.fromARGB(255, 255, 69, 0));
      expect(sunsetPalette.mediumHigh, const Color.fromARGB(255, 255, 99, 71));
      expect(sunsetPalette.high, const Color.fromARGB(255, 243, 96, 175));
      expect(sunsetPalette.veryHigh, const Color.fromARGB(255, 255, 0, 0));
    });

    test('oceanPalette should have correct colors', () {
      expect(oceanPalette.low, const Color.fromARGB(255, 173, 216, 230));
      expect(oceanPalette.mediumLow, const Color.fromARGB(255, 70, 130, 180));
      expect(oceanPalette.medium, const Color.fromARGB(255, 30, 144, 255));
      expect(oceanPalette.mediumHigh, const Color.fromARGB(255, 0, 191, 255));
      expect(oceanPalette.high, const Color.fromARGB(255, 0, 0, 255));
      expect(oceanPalette.veryHigh, const Color.fromARGB(255, 0, 0, 139));
    });

    test('tropicalPalette should have correct colors', () {
      expect(tropicalPalette.low, const Color.fromARGB(255, 255, 255, 224));
      expect(tropicalPalette.mediumLow, const Color.fromARGB(255, 255, 215, 0));
      expect(tropicalPalette.medium, const Color.fromARGB(255, 255, 165, 0));
      expect(
          tropicalPalette.mediumHigh, const Color.fromARGB(255, 34, 139, 34));
      expect(tropicalPalette.high, const Color.fromARGB(255, 60, 179, 113));
      expect(tropicalPalette.veryHigh, const Color.fromARGB(255, 0, 100, 0));
    });
  });
}
