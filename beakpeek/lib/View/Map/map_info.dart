import 'package:beakpeek/View/Home/Searching/local_search_container.dart';
import 'package:beakpeek/Styles/colors.dart';
import 'package:beakpeek/View/Map/bird_map.dart';
import 'package:flutter/material.dart';
import 'package:beakpeek/Model/nav.dart';

class MapInfo extends StatelessWidget {
  const MapInfo({super.key});

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
                        child: const LocalSearchContainer(
                          province: 'Gauteng',
                          helpContent:
                              '''This map shows you your current location. 
                          Click anywhere and you will see all the birds in that area! 
                          You can use the filters to customise what you see. 
                          You can use the search bar to see the heat map of a specific bird!''',
                        ),
                      ),
                      const Expanded(
                        child: BirdMap(),
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
