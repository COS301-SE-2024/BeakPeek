// ignore_for_file: lines_longer_than_80_chars

import 'package:beakpeek/Model/top_search_bar.dart';
import 'package:beakpeek/View/Map/heat_map.dart';
import 'package:flutter/material.dart';
import 'package:beakpeek/Model/nav.dart';
import 'package:beakpeek/Styles/map_page_styles.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFFF3F1ED),
      body: Center(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                // child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        const TopSearchBar(),
                        const SizedBox(height: 20),
                        RichText(
                          text: const TextSpan(
                            text: 'Your Area Map',
                            style: MapPageStyles.mapHeadingGreen,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: HeatMap(id: id),
                        )
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
