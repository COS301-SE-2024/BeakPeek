import 'dart:ui';

import 'package:flutter/material.dart';

class ColorPalette {
  final Color low;
  final Color mediumLow;
  final Color medium;
  final Color mediumHigh;
  final Color high;
  final Color veryHigh;

  ColorPalette({
    required this.low,
    required this.mediumLow,
    required this.medium,
    required this.mediumHigh,
    required this.high,
    required this.veryHigh,
  });
}

// Example palettes
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

// Add more palettes as needed
