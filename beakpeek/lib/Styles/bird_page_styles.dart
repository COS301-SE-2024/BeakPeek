import 'package:flutter/material.dart';

abstract class BirdPageStyles {
  static const Color primaryColor = Color(0xFF033A30);
  static const Color secondaryColor = Color.fromARGB(188, 3, 58, 48);
  static const Color iconColorDarkMode = Color.fromARGB(255, 180, 180, 180);
  static const Color iconColorLightMode = Color.fromARGB(255, 58, 58, 58);
  static const double borderRadius = 30.0;

  static const TextStyle heading = TextStyle(
    color: primaryColor,
    fontSize: 32,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subheading = TextStyle(
    color: secondaryColor,
    fontSize: 20,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.bold,
  );

  static const TextStyle content = TextStyle(
    color: Colors.black87,
    fontSize: 18,
    fontFamily: 'SF Pro Display',
  );

  static const TextStyle secondaryContent = TextStyle(
    color: Colors.black54,
    fontSize: 18,
    fontFamily: 'SF Pro Display',
  );

  static const TextStyle smallContent = TextStyle(
    color: Colors.black38,
    fontSize: 18,
    fontFamily: 'SF Pro Display',
  );

  static const TextStyle buttonText = TextStyle(
    color: Colors.white,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w500,
    fontSize: 18,
  );

  static ButtonStyle elevatedButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      minimumSize: const Size(250, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      shadowColor: Colors.black,
    ).copyWith(
      foregroundColor: WidgetStateProperty.all(buttonText.color),
      textStyle: WidgetStateProperty.all(buttonText),
    );
  }
}
