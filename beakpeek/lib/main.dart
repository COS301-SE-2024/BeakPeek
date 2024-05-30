import 'package:flutter/material.dart';
import 'package:beakpeek/landing_tab_1_light.dart';  // Make sure to adjust the import path

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bird-Watching Companion',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: LandingTab1Light(),
      ),
    );
  }
}
