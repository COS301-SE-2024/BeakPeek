import 'package:beakpeek/View/Home/home.dart';
import 'package:beakpeek/View/Login/landing_page.dart';
import 'package:beakpeek/View/Home/map_info.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => const LandingPage(),
        '/home': (context) => const Home(),
        '/map': (context) => const MapInfo(),
      },
    ),
  );
}
