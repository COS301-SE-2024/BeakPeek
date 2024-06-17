// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:beakpeek/LandingText/custom_buttons.dart';
import 'package:beakpeek/LandingText/custom_text_span.dart';
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
                  const CustomOutlinedButton(
                    routePath: '/signup',
                    buttonText: 'Sign Up',
                    backgroundColor: Color(0xff033A30),
                    textColor: Color(0xff033A30),
                  ),
                  const SizedBox(height: 20),
                  const CustomFilledButton(
                    routePath: '/login',
                    buttonText: 'Sign In',
                    backgroundColor: Color(0xff033A30),
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
            Image.asset(
              'assets/images/landing2Resize.png',
              fit: BoxFit.fitWidth,
            ),
          ],
        ),
      ),
    );
  }
}
