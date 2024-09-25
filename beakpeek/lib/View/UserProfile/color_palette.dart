// ignore_for_file: library_private_types_in_public_api

import 'package:beakpeek/Controller/Main/color_palette_functions.dart';
import 'package:flutter/material.dart';

class PaletteSelector extends StatefulWidget {
  const PaletteSelector({super.key});

  @override
  _PaletteSelectorState createState() => _PaletteSelectorState();
}

class _PaletteSelectorState extends State<PaletteSelector> {
  ColorPalette selectedPalette = greenRedPalette; // Default palette

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Select a Color Palette:'),
        DropdownButton<ColorPalette>(
          value: selectedPalette,
          items: [
            DropdownMenuItem(
              value: greenRedPalette,
              child: const Text('Green-Red'),
            ),
            DropdownMenuItem(
              value: bluePurplePalette,
              child: const Text('Blue-Purple'),
            ),
            // Add more palette options here
          ],
          onChanged: (newPalette) {
            setState(() {
              selectedPalette = newPalette!;
            });
          },
        ),
      ],
    );
  }
}
