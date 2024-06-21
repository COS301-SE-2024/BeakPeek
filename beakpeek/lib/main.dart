import 'package:beakpeek/View/Home/bird_search.dart';
import 'package:beakpeek/View/Home/home.dart';
import 'package:beakpeek/View/Login/landing_page.dart';
import 'package:beakpeek/View/Home/map_info.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: <String, WidgetBuilder>{
      '/': (context) => const LandingPage(),
      '/home': (context) => const Home(),
      '/map': (context) => const MapInfo(),
      '/oauthredirect': (context) => const home(),
    },
  ));
}
