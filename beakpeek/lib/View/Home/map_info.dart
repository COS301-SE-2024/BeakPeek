import 'package:beakpeek/Styles/map_page_styles.dart';
import 'package:beakpeek/View/Home/map.dart';
import 'package:flutter/material.dart';
import 'package:beakpeek/LandingText/nav.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFF3F1ED),
        body: MapInfo(),
      ),
    );
  }
}

class MapInfo extends StatelessWidget {
  const MapInfo({super.key});

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
                          const Expanded(
                            child: MapSample(),
                          ),
                        ],
                      )),
                ),
                const BottomNavigation(),
              ],
            ),
          ),
        ));
  }
}

