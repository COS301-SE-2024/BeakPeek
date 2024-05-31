import 'package:beakpeek/landing_tab_1_light.dart';
import 'package:beakpeek/landing_tab_2_light.dart';
import 'package:beakpeek/log_in.dart';
import 'package:beakpeek/sign_up.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() {
    return _LandingPageState();
  }
}

class _LandingPageState extends State<LandingPage> {
  Widget? activeScreen;

  void loginFunc() {
    setState(() {
      activeScreen = const LogIn();
    });
  }

  void signinFunc() {
    setState(() {
      activeScreen = const SignUp();
    });
  }

  @override
  void initState() {
    activeScreen = PageView(
      children: [
        const LandingTab1Light(),
        LandingTab2Light(signinFunc, loginFunc),
      ],
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFF3F1ED),
        body: activeScreen,
      ),
    );
  }
}
