import 'package:beakpeek/Styles/colors.dart';
import 'package:beakpeek/config_azure.dart';
import 'package:flutter/material.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:go_router/go_router.dart';
import 'package:localstorage/localstorage.dart';
import 'package:beakpeek/config_azure.dart' as config;

class LandingTab1 extends StatelessWidget {
  const LandingTab1({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor(context),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: screenHeight * 0.45,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/landing1.png',
                width: screenWidth,
                height: screenHeight * 0.6,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    if (accessToken.isNotEmpty &&
                        localStorage.getItem('termsAndCondition') != null)
                      Center(
                        child: FilledButton(
                          style: GlobalStyles.buttonPrimaryOutlined(context),
                          child: Text(
                            '''Welcome Back ${localStorage.getItem("username")}''',
                            style: GlobalStyles.secondaryButtonText(context),
                          ),
                          onPressed: () {
                            config.loggedIN = true;
                            context.go('/home');
                          },
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
