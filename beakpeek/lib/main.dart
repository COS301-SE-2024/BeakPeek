import 'package:beakpeek/bird_search.dart';
import 'package:beakpeek/home.dart';
import 'package:beakpeek/landing_page.dart';
import 'package:beakpeek/log_in.dart';
import 'package:beakpeek/map_info.dart';
import 'package:beakpeek/sign_up.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MaterialApp(
    initialRoute: '/birdSearch',
    routes: <String, WidgetBuilder>{
      '/': (context) => const LandingPage(),
      '/login': (context) => const LogIn(),
      '/signup': (context) => const SignUp(),
      '/home': (context) => const home(),
      '/birdSearch': (context) => const BirdSearch(),
    },
  ));
}
