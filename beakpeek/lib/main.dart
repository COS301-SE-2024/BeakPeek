import 'package:beakpeek/Controller/router_provider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: <String, WidgetBuilder>{
      '/': (context) => const LandingPage(),
      '/login': (context) => const LogIn(),
      '/signup': (context) => const SignUp(),
      '/home': (context) => const Home(),
      '/map': (context) => const MapInfo(),
      '/oauthredirect': (context) => const home(),
    },
  ));
}
