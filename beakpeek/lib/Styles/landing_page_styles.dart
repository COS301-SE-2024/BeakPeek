import 'package:flutter/widgets.dart';

abstract class LandingStyles {
  static const TextStyle loginHeadingDark = TextStyle(
    color: Color(0xFF033A30),
    fontSize: 44,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w700,
    height: 0,
  );

  static const TextStyle loginHeadingYellow = TextStyle(
    color: Color(0xFFECAD31),
    fontSize: 44,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w700,
    height: 0,
  );

  static const TextStyle landingPageHeading = TextStyle(
    color: Color.fromARGB(255, 139, 107, 77),
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
}
