// ignore_for_file: lines_longer_than_80_chars
import 'package:flutter/material.dart';
import 'package:beakpeek/Styles/landing_page_styles.dart';

class LandingTab1 extends StatelessWidget {
  const LandingTab1({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        verticalDirection: VerticalDirection.up,
        children: [
          Image.asset(
            'assets/images/landing1.png',
          ),
          const SizedBox(
            height: 50,
          ),
          RichText(
            text: const TextSpan(
              text: 'Your Ultimate',
              style: LandingStyles.loginHeadingBlack,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          RichText(
            text: const TextSpan(
              text: 'Bird-Watching',
              style: LandingStyles.loginHeadingYellow,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          RichText(
            text: const TextSpan(
              text: 'Companion',
              style: LandingStyles.loginHeadingBlack,
            ),
          ),
        ],
      ),
    );
  }
}
