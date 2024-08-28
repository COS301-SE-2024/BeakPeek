import 'package:beakpeek/Controller/Azure/login.dart';
import 'package:beakpeek/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:go_router/go_router.dart';

class LandingTab2 extends StatelessWidget {
  const LandingTab2({super.key});
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Spacer(flex: (screenHeight * 0.05).toInt()),
                  Align(
                    alignment: const Alignment(-0.7, 0.0),
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        style: GlobalStyles.mainHeadingPrimary(context),
                        children: [
                          TextSpan(
                              text: 'Explore,\n',
                              style: GlobalStyles.mainHeadingPrimary(context)),
                          TextSpan(
                            text: 'Discover,\n',
                            style: GlobalStyles.mainHeadingTertiary(context),
                          ),
                          TextSpan(
                              text: 'and Share',
                              style: GlobalStyles.mainHeadingPrimary(context)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Align(
                    alignment: const Alignment(-0.5, 0.0),
                    child: RichText(
                      text: TextSpan(
                        style: GlobalStyles.contentPrimary(context),
                        children: const <TextSpan>[
                          TextSpan(
                            text: 'Create an account or sign in \nto join the',
                          ),
                          TextSpan(
                            text: ' BeakPeak',
                            style: TextStyle(
                              color: Color.fromARGB(255, 219, 76, 20),
                              fontSize: 18,
                              fontFamily: 'SF Pro Display',
                            ),
                          ),
                          TextSpan(
                            text: ' community.',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(flex: (screenHeight * 0.03).toInt()),
                  OutlinedButton(
                    style: GlobalStyles.buttonPrimaryFilled(context),
                    child: Text('Sign Up / Sign In',
                        style: GlobalStyles.primaryButtonText(context)),
                    onPressed: () {
                      loginFunction(context);
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  FilledButton(
                    style: GlobalStyles.buttonPrimaryOutlined(context),
                    child: Text('Sign In as Guest',
                        style: GlobalStyles.secondaryButtonText(context)),
                    onPressed: () {
                      context.go('/home');
                    },
                  ),
                ],
              ),
            ),
            Image.asset(
              'assets/images/landing2.png',
              height: screenHeight * 0.45,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
