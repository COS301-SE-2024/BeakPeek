import 'package:beakpeek/Module/top_search_bar.dart';
import 'package:beakpeek/View/Home/bird_map.dart';
import 'package:flutter/material.dart';
import 'package:beakpeek/LandingText/cust_rich_text.dart';
import 'package:beakpeek/Module/nav.dart';

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
    return const Scaffold(
        backgroundColor: Color(0xFFF3F1ED),
        body: Center(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  // child: SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          TopSearchBar(),
                          SizedBox(height: 20),
                          CustRichText(
                            'Your Area Map',
                            Color(0xFF033A30),
                            ta: TextAlign.left,
                            fontS: 22,
                          ),
                          SizedBox(height: 10),
                          Expanded(
                            child: BirdMap(),
                          ),
                        ],
                      )),
                ),
                BottomNavigation(),
              ],
            ),
          ),
        ));
  }
}