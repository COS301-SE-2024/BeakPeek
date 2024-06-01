import 'package:beakpeek/LandingText/login_stack.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String? jwtToken;
  String? refreshToken;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F1ED),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LoginStack(),
            IconButton(
              icon: Image.asset('assets/icons/google.png'),
              onPressed: () {},
              tooltip: 'Sign in with google',
            ),
            IconButton(
              icon: Image.asset('assets/icons/facebook.png'),
              onPressed: () {},
              tooltip: 'Sign in with google',
            ),
          ],
        ),
      ),
    );
  }
}
