import 'package:beakpeek/Styles/global_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GlobalStyles', () {
    test('primaryColor is correct', () {
      expect(GlobalStyles.primaryColor, const Color(0xFF033A30));
    });

    test('secondaryColor is correct', () {
      expect(
        GlobalStyles.secondaryColor,
        const Color.fromARGB(188, 3, 58, 48),
      );
    });

    test('tertiaryColor is correct', () {
      expect(
        GlobalStyles.tertiaryColor,
        const Color.fromARGB(255, 197, 140, 35),
      );
    });

    test('iconColorDarkMode is correct', () {
      expect(
        GlobalStyles.iconColorDarkMode,
        const Color.fromARGB(255, 180, 180, 180),
      );
    });

    test('iconColorLightMode is correct', () {
      expect(
        GlobalStyles.iconColorLightMode,
        const Color.fromARGB(255, 58, 58, 58),
      );
    });

    test('borderRadius is correct', () {
      expect(GlobalStyles.borderRadius, 30.0);
    });

    test('mainHeadingDark TextStyle is correct', () {
      expect(
          GlobalStyles.mainHeadingDark,
          const TextStyle(
            color: GlobalStyles.primaryColor,
            fontSize: 44,
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.w700,
            height: 0,
          ));
    });

    test('mainHeadingLight TextStyle is correct', () {
      expect(
          GlobalStyles.mainHeadingLight,
          const TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 44,
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.w700,
            height: 0,
          ));
    });

    test('mainHeadingYellow TextStyle is correct', () {
      expect(
          GlobalStyles.mainHeadingYellow,
          const TextStyle(
            color: Color(0xFFECAD31),
            fontSize: 44,
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.w700,
            height: 0,
          ));
    });
  });
}
