import 'package:beakpeek/landing_tab_1_light.dart';
import 'package:beakpeek/landing_tab_2_light.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() {
    return _LandingPageState();
  }
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F1ED),
      body: PageView(
        children: const [
          LandingTab1Light(),
          LandingTab2Light(),
        ],
      ),
    );
  }
}
