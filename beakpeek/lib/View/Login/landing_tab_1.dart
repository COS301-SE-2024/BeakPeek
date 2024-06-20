// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:beakpeek/Styles/landing_page_styles.dart';

class LandingTab1 extends StatelessWidget {
  const LandingTab1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0EDE6),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: LandingStyles.loginHeadingDark,
                        children: [
                          TextSpan(text: 'Your Ultimate\n'),
                          TextSpan(
                              text: 'Bird-Watching\n',
                              style: LandingStyles.loginHeadingYellow),
                          TextSpan(
                            text: 'Companion',
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 170),
                      child: Image.asset(
                        'assets/images/landing1.png',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
