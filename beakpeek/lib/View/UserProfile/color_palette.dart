import 'package:flutter/material.dart';
import 'package:beakpeek/Model/Globals/globals.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:beakpeek/Styles/colors.dart';
import 'package:beakpeek/Controller/Main/color_palette_functions.dart';

class PaletteSelector extends StatelessWidget {
  const PaletteSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.iconColor(context)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Select Color Palette',
          style: GlobalStyles.smallHeadingPrimary(context),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '''Select an option to change the colour palette used for heat maps.''',
              style:
                  GlobalStyles.contentPrimary(context).copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          _buildPaletteOption(context, greenRedPalette, 'Green-Red'),
          _buildPaletteOption(context, bluePurplePalette, 'Blue-Purple'),
          _buildPaletteOption(context, earthyPalette, 'Earthy'),
          _buildPaletteOption(context, sunsetPalette, 'Sunset'),
          _buildPaletteOption(context, oceanPalette, 'Ocean'),
          _buildPaletteOption(context, tropicalPalette, 'Tropical'),
        ],
      ),
    );
  }

  Widget _buildPaletteOption(
      BuildContext context, ColorPalette palette, String title) {
    return GestureDetector(
      onTap: () {
        global.palette = palette;
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: AppColors.popupColor(context),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GlobalStyles.contentPrimary(context),
              ),
              const SizedBox(height: 10),
              Center(
                child: _buildColorSwatches(palette, context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorSwatches(ColorPalette palette, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Low',
          style: TextStyle(
            fontSize: screenWidth * 0.03,
            color: AppColors.primaryColor(context),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildColorSwatch(palette.low, context),
              _buildColorSwatch(palette.mediumLow, context),
              _buildColorSwatch(palette.medium, context),
              _buildColorSwatch(palette.mediumHigh, context),
              _buildColorSwatch(palette.high, context),
              _buildColorSwatch(palette.veryHigh, context),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'Very High',
          style: TextStyle(
            fontSize: screenWidth * 0.03,
            color: AppColors.primaryColor(context),
          ),
        ),
      ],
    );
  }

  Widget _buildColorSwatch(Color color, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.10,
      height: screenWidth * 0.05,
      color: color,
    );
  }
}
