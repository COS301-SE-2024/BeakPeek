// ignore_for_file: lines_longer_than_80_chars

import 'package:beakpeek/View/Home/Searching/filterable_searchbar.dart';
import 'package:beakpeek/View/Map/heat_map.dart';
import 'package:flutter/material.dart';
import 'package:beakpeek/Model/nav.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFF3F1ED),
        body: MapInfo(id: 0),
      ),
    );
  }
}

class MapInfo extends StatelessWidget {
  const MapInfo({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFF3F1ED),
      body: Center(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
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
                        Expanded(child: HeatMap(id: id)),
                      ],
                    )),
              ),
              const BottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }
}
