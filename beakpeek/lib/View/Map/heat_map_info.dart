// ignore_for_file: lines_longer_than_80_chars

import 'package:beakpeek/Styles/colors.dart';
import 'package:beakpeek/View/Home/Searching/filterable_searchbar.dart';
import 'package:beakpeek/View/Map/heat_map.dart';
import 'package:flutter/material.dart';
import 'package:beakpeek/Model/nav.dart';

// ignore: must_be_immutable
class HeatMapInfo extends StatelessWidget {
  const HeatMapInfo({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor(context),
      body: Center(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: screenWidth * 0.04),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.05),
                      Padding(
                        padding: EdgeInsets.only(
                            right: screenWidth * 0.04,
                            left: screenHeight * 0.02),
                        child: const FilterableSearchbar(
                          helpContent:
                              '''This map shows you your current location. 
                          Click anywhere and you will see all the birds in that area! 
                          You can use the filters to customise what you see. 
                          You can use the search bar to see the heat map of a specific bird!''',
                        ),
                      ),
                      Expanded(
                        child: HeatMap(id: id),
                      ),
                    ],
                  ),
                ),
              ),
              const BottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }
}
