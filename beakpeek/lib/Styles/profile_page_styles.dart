import 'package:beakpeek/Styles/global_styles.dart';
import 'package:flutter/material.dart';

abstract class ProfilePageStyles {
  static const Color iconColorDarkMode = Color.fromARGB(255, 180, 180, 180);
  static const Color iconColorLightMode = Color.fromARGB(255, 58, 58, 58);

  static ButtonStyle elevatedButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: GlobalStyles.primaryColor,
      minimumSize: const Size(300, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      shadowColor: Colors.black,
    ).copyWith(
      foregroundColor:
          WidgetStateProperty.all(GlobalStyles.primaryButtonText.color),
      textStyle: WidgetStateProperty.all(GlobalStyles.primaryButtonText),
    );
  }
}
