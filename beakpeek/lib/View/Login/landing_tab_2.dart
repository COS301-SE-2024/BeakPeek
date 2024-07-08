// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:beakpeek/Styles/custom_text_span.dart';
import 'package:beakpeek/Styles/landing_page_styles.dart';

class LandingTab2 extends StatelessWidget {
  const LandingTab2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0EDE6),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  const Spacer(flex: 5),
                  Align(
                    alignment: const Alignment(-0.7, 0.0),
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: const TextSpan(
                        style: LandingStyles.loginHeadingDark,
                        children: [
                          TextSpan(
                            text: 'Explore,\n',
                          ),
                          TextSpan(
                            text: 'Discover,\n',
                            style: LandingStyles.loginHeadingYellow,
                          ),
                          TextSpan(
                            text: 'and Share',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment(-0.5, 0.0),
                    child: CustTextSpan(),
                  ),
                  const Spacer(flex: 3),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xff033A30),
                      ),
                      backgroundColor: Colors.transparent,
                      minimumSize: const Size(350, 50),
                    ),
                    child: const Text('Sign Up / Sign In',
                        style: LandingStyles.secondaryButtonText),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xff033A30),
                      minimumSize: const Size(350, 50),
                      shadowColor: Colors.black,
                    ),
                    child: const Text('Sign In as Guest',
                        style: LandingStyles.primaryButtonText),
                  ),
                ],
              ),
            ),
            Image.asset(
              'assets/images/landing2.png',
              height: 450,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
