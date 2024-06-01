import 'package:beakpeek/landing_page.dart';
import 'package:beakpeek/log_in.dart';
import 'package:beakpeek/sign_up.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: <String, WidgetBuilder>{
      '/': (context) => const LandingPage(),
      '/login': (context) => const LogIn(),
      '/signup': (context) => const SignUp()
    },
  ));
}
