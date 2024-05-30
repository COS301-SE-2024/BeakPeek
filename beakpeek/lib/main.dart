import 'package:flutter/material.dart';
import 'package:beakpeek/landing_tab_1_light.dart';
import 'package:beakpeek/landing_tab_2_light.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: const [
          LandingTab1Light(),
          LandingTab2Light(),
        ],
      ),
    );
  }
}
