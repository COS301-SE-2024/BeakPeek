import 'package:flutter/material.dart';
import 'package:beakpeek/Styles/global_styles.dart';

class LandingTab1 extends StatelessWidget {
  const LandingTab1({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                    SizedBox(
                      height: screenHeight * 0.1,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: GlobalStyles.mainHeadingDark,
                        children: [
                          TextSpan(text: 'Your Ultimate\n'),
                          TextSpan(
                              text: 'Bird-Watching\n',
                              style: GlobalStyles.mainHeadingYellow),
                          TextSpan(
                            text: 'Companion',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.00),
              child: Image.asset(
                'assets/images/landing1.png',
                width: screenWidth * 0.9,
                height: screenHeight * 0.5,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
