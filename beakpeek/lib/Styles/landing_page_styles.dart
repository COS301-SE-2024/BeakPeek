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

  static const TextStyle baseTextStyle = TextStyle(
    color: Color(0xB200383E),
    fontSize: 20,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w400,
  );

  static const TextStyle highlightedTextStyle = TextStyle(
    color: Color(0xFFCE7625),
  );
}
