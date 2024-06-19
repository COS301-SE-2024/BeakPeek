import 'package:beakpeek/LandingText/signup_stack.dart';
import 'package:flutter/material.dart';
import 'package:beakpeek/Model/login_function.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _SignUpState();
}

class _SignUpState extends State<LogIn> {
  final FlutterAppAuth appAuth = const FlutterAppAuth();

  void setResult() {
    getResults(appAuth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F1ED),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SignupStack(),
            IconButton(
              icon: Image.asset('assets/icons/google.png'),
              onPressed: () {},
              tooltip: 'Sign in with google',
            ),
            IconButton(
              icon: Image.asset('assets/icons/facebook.png'),
              onPressed: () => setResult(),
              tooltip: 'Sign in with google',
            ),
          ],
        ),
      ),
    );
  }
}
