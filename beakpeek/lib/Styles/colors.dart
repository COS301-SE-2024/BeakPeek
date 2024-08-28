import 'package:flutter/material.dart';

abstract class AppColors {
  // Light mode colors
  static const Color primaryColorLight = Color(0xff033a30);
  static const Color secondaryColorLight = Color.fromARGB(188, 3, 58, 48);
  static const Color tertiaryColorLight = Color(0xffecad31);
  static const Color greyColorLight = Color(0xff888888);
  static const Color backgroundColorLight = Color(0xfff3f1eD);
  static const Color popupColorLight = Color(0xffffffff);
  static const Color textColorLight = Color(0xff000000);
  static const Color primaryButtonTextColorLight = Color(0xffffffff);
  static const Color secondaryButtonTextColorLight = Color(0xff033a30);
  static const Color iconColorLight = primaryColorLight;

  // Dark mode colors
  static const Color primaryColorDark = Color(0xffdde6e4);
  static const Color secondaryColorDark = Color(0xff999999);
  static const Color tertiaryColorDark = Color.fromARGB(255, 199, 148, 47);
  static const Color greyColorDark = Color(0xff888888);
  static const Color backgroundColorDark = Color.fromARGB(255, 24, 37, 33);
  static const Color popupColorDark = Color.fromARGB(255, 35, 54, 50);
  static const Color textColorDark = Color(0xffdde6e4);
  static const Color primaryButtonTextColorDark = Color(0xffdde6e4);
  static const Color secondaryButtonTextColorDark = Color(0xffdde6e4);
  static const Color iconColorDark = primaryColorDark;

  // Get primary color
  static Color primaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? primaryColorDark
        : primaryColorLight;
  }

  // Get primary button colour
  static Color primaryButtonColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? popupColorDark
        : primaryColorLight;
  }

// Get secondary color
  static Color secondaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? primaryColorDark
        : primaryColorLight;
  }

  // Get teriary color
  static Color tertiaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? tertiaryColorDark
        : tertiaryColorLight;
  }

  // Get icon color
  static Color iconColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? primaryColorDark
        : primaryColorLight;
  }

  // Get text color
  static Color textColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? textColorDark
        : textColorLight;
  }

  // Get grey text color
  static Color greyColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? greyColorDark
        : greyColorLight;
  }

  // Get background color
  static Color backgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? backgroundColorDark
        : backgroundColorLight;
  }

  // Get popup background color
  static Color popupColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? popupColorDark
        : popupColorLight;
  }

  // Get primary button text color
  static Color primaryButtonTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? primaryButtonTextColorDark
        : primaryButtonTextColorLight;
  }

  // Get secondary button text color
  static Color secondaryButtonTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? secondaryButtonTextColorDark
        : secondaryButtonTextColorLight;
  }
}
