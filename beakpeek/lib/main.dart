import 'package:beakpeek/View/Home/bird_search.dart';
import 'package:beakpeek/View/Home/home.dart';
import 'package:beakpeek/View/Login/landing_page.dart';
import 'package:beakpeek/log_in.dart';
import 'package:beakpeek/View/Home/map_info.dart';
import 'package:beakpeek/sign_up.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: <String, WidgetBuilder>{
      '/': (context) => const LandingPage(),
      '/login': (context) => const LogIn(),
      '/signup': (context) => const SignUp(),
      '/home': (context) => const Home(),
      '/birdSearch': (context) => const BirdSearch(),
      '/map': (context) => const MapInfo(),
    },
  ));
}
