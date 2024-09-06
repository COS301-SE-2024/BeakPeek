import 'package:beakpeek/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:beakpeek/Styles/global_styles.dart';

class LandingTab1 extends StatelessWidget {
  const LandingTab1({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor(context),
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
                      text: TextSpan(
                        style: GlobalStyles.mainHeadingPrimary(context),
                        children: [
                          TextSpan(
                              text: 'Your Ultimate\n',
                              style: GlobalStyles.mainHeadingPrimary(context)),
                          TextSpan(
                              text: 'Bird-Watching\n',
                              style: GlobalStyles.mainHeadingTertiary(context)),
                          TextSpan(
                              text: 'Companion',
                              style: GlobalStyles.mainHeadingPrimary(context)),
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
