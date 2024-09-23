import 'package:beakpeek/Controller/Main/color_palette_functions.dart';
import 'package:flutter/material.dart';

class PaletteSelector extends StatefulWidget {
  @override
  _PaletteSelectorState createState() => _PaletteSelectorState();
}

class _PaletteSelectorState extends State<PaletteSelector> {
  ColorPalette selectedPalette = greenRedPalette; // Default palette

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Select a Color Palette:'),
        DropdownButton<ColorPalette>(
          value: selectedPalette,
          items: [
            DropdownMenuItem(
              value: greenRedPalette,
              child: Text('Green-Red'),
            ),
            DropdownMenuItem(
              value: bluePurplePalette,
              child: Text('Blue-Purple'),
            ),
            // Add more palette options here
          ],
          onChanged: (ColorPalette? newPalette) {
            setState(() {
              selectedPalette = newPalette!;
            });
          },
        ),
      ],
    );
  }
}
