import 'package:flutter/material.dart';

abstract class GlobalStyles {
  static const TextStyle mainHeadingDark = TextStyle(
    color: Color(0xFF033A30),
    fontSize: 44,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w700,
    height: 0,
  );

  static const TextStyle mainHeadingLight = TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 44,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w700,
    height: 0,
  );

  static const TextStyle mainHeadingYellow = TextStyle(
    color: Color(0xFFECAD31),
    fontSize: 44,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w700,
    height: 0,
  );

  static const TextStyle primaryButtonText = TextStyle(
    color: Color(0xFFFFFFFF),
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w500,
    fontSize: 18,
  );

  static const TextStyle secondaryButtonText = TextStyle(
    color: Color(0xff033A30),
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w500,
    fontSize: 18,
  );

  static final ButtonStyle primaryButton = FilledButton.styleFrom(
    backgroundColor: const Color(0xff033A30),
    minimumSize: const Size(350, 50),
    shadowColor: Colors.black,
  );

  static final ButtonStyle secondaryButton = OutlinedButton.styleFrom(
    backgroundColor: Colors.transparent,
    minimumSize: const Size(350, 50),
    shadowColor: Colors.black,
    side: const BorderSide(
      color: Color(0xff033A30),
    ),
  );
}
