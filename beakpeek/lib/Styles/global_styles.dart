import 'package:flutter/material.dart';

abstract class GlobalStyles {
  static const Color primaryColor = Color(0xFF033A30);
  static const Color secondaryColor = Color.fromARGB(188, 3, 58, 48);
  static const Color tertiaryColor = Color.fromARGB(255, 197, 140, 35);
  static const Color iconColorDarkMode = Color.fromARGB(255, 180, 180, 180);
  static const Color iconColorLightMode = Color.fromARGB(255, 58, 58, 58);
  static const double borderRadius = 30.0;

  static const TextStyle mainHeadingDark = TextStyle(
    color: primaryColor,
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

  static const TextStyle subHeadingDark = TextStyle(
    color: primaryColor,
    fontSize: 32,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w700,
    height: 0,
  );

  static const TextStyle smallHeadingDark = TextStyle(
    color: primaryColor,
    fontSize: 20,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subheadingLight = TextStyle(
    color: secondaryColor,
    fontSize: 20,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.bold,
  );

  static const TextStyle content = TextStyle(
    color: Colors.black87,
    fontSize: 17,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w400,
  );

  static const TextStyle greenContent = TextStyle(
    color: primaryColor,
    fontSize: 17,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w500,
  );

  static const TextStyle boldContent = TextStyle(
    color: secondaryColor,
    fontSize: 18,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.bold,
  );

  static const TextStyle secondaryContent = TextStyle(
    color: Color.fromARGB(255, 201, 138, 12),
    fontSize: 16,
    fontFamily: 'SF Pro Display',
  );

  static const TextStyle greyContent = TextStyle(
    color: Color.fromARGB(255, 119, 119, 119),
    fontSize: 16,
    fontFamily: 'SF Pro Display',
  );

  static const TextStyle smallContent = TextStyle(
    color: Colors.black38,
    fontSize: 16,
    fontFamily: 'SF Pro Display',
  );

  static final ButtonStyle primaryButton = FilledButton.styleFrom(
    backgroundColor: primaryColor,
    minimumSize: const Size(350, 50),
    shadowColor: Colors.grey, // Changed to grey
    elevation: 5, // Added elevation
  );

  static final ButtonStyle secondaryButton = OutlinedButton.styleFrom(
    backgroundColor: Colors.transparent,
    minimumSize: const Size(350, 50),
    shadowColor: Colors.grey, // Changed to grey
    side: const BorderSide(
      color: primaryColor,
    ),
  );

  static const TextStyle primaryButtonText = TextStyle(
    color: Color(0xFFFFFFFF),
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w500,
    fontSize: 18,
  );

  static const TextStyle secondaryButtonText = TextStyle(
    color: primaryColor,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w500,
    fontSize: 18,
  );

  static ButtonStyle elevatedButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: GlobalStyles.primaryColor,
      minimumSize: const Size(150, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      shadowColor: Colors.grey,
    ).copyWith(
      foregroundColor:
          WidgetStateProperty.all(GlobalStyles.primaryButtonText.color),
      textStyle: WidgetStateProperty.all(GlobalStyles.primaryButtonText),
    );
  }
}
