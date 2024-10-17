import 'package:flutter/material.dart';

class ColorPalette {
  ColorPalette({
    required this.low,
    required this.mediumLow,
    required this.medium,
    required this.mediumHigh,
    required this.high,
    required this.veryHigh,
  });
  final Color low;
  final Color mediumLow;
  final Color medium;
  final Color mediumHigh;
  final Color high;
  final Color veryHigh;
}

final ColorPalette greenRedPalette = ColorPalette(
  low: const Color.fromARGB(255, 255, 115, 105), // light red
  mediumLow: Colors.red,
  medium: Colors.orange,
  mediumHigh: Colors.yellow,
  high: const Color.fromARGB(255, 103, 255, 108), // light green
  veryHigh: const Color.fromARGB(255, 1, 201, 34), // dark green
);

final ColorPalette bluePurplePalette = ColorPalette(
  low: const Color.fromARGB(255, 135, 206, 235), // light blue
  mediumLow: Colors.blue,
  medium: Colors.indigo,
  mediumHigh: Colors.purple,
  high: const Color.fromARGB(255, 186, 85, 211), // medium purple
  veryHigh: const Color.fromARGB(255, 138, 43, 226), // dark purple
);

final ColorPalette earthyPalette = ColorPalette(
  low: const Color.fromARGB(255, 210, 180, 140), // Light brown
  mediumLow: const Color.fromARGB(255, 139, 69, 19), // Brown
  medium: const Color.fromARGB(255, 160, 82, 45), // Saddle brown
  mediumHigh: const Color.fromARGB(255, 113, 153, 113), // Forest green
  high: const Color.fromARGB(255, 60, 179, 113), // Medium sea green
  veryHigh: const Color.fromARGB(255, 0, 128, 0), // Green
);

final ColorPalette sunsetPalette = ColorPalette(
  low: const Color.fromARGB(255, 255, 228, 196), // Light peach
  mediumLow: const Color.fromARGB(255, 255, 140, 0), // Dark orange
  medium: const Color.fromARGB(255, 255, 69, 0), // Red orange
  mediumHigh: const Color.fromARGB(255, 255, 99, 71), // Tomato
  high: const Color.fromARGB(255, 243, 96, 175), // Deep pink
  veryHigh: const Color.fromARGB(255, 255, 0, 0), // Red
);

final ColorPalette oceanPalette = ColorPalette(
  low: const Color.fromARGB(255, 173, 216, 230), // Light blue
  mediumLow: const Color.fromARGB(255, 70, 130, 180), // Steel blue
  medium: const Color.fromARGB(255, 30, 144, 255), // Dodger blue
  mediumHigh: const Color.fromARGB(255, 0, 191, 255), // Deep sky blue
  high: const Color.fromARGB(255, 0, 0, 255), // Blue
  veryHigh: const Color.fromARGB(255, 0, 0, 139), // Dark blue
);

final ColorPalette tropicalPalette = ColorPalette(
  low: const Color.fromARGB(255, 255, 255, 224), // Light yellow
  mediumLow: const Color.fromARGB(255, 255, 215, 0), // Gold
  medium: const Color.fromARGB(255, 255, 165, 0), // Orange
  mediumHigh: const Color.fromARGB(255, 34, 139, 34), // Forest green
  high: const Color.fromARGB(255, 60, 179, 113), // Medium sea green
  veryHigh: const Color.fromARGB(255, 0, 100, 0), // Dark green
);
