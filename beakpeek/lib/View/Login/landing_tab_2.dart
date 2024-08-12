import 'package:beakpeek/Controller/Azure/login.dart';
import 'package:flutter/material.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:go_router/go_router.dart';

class LandingTab2 extends StatelessWidget {
  const LandingTab2({super.key});
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffF0EDE6),
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
                      text: const TextSpan(
                        style: GlobalStyles.mainHeadingDark,
                        children: [
                          TextSpan(
                            text: 'Explore,\n',
                          ),
                          TextSpan(
                            text: 'Discover,\n',
                            style: GlobalStyles.mainHeadingYellow,
                          ),
                          TextSpan(
                            text: 'and Share',
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Align(
                    alignment: const Alignment(-0.5, 0.0),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontFamily: 'SF Pro Display',
                        ),
                        children: <TextSpan>[
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
                    style: GlobalStyles.secondaryButton,
                    child: const Text('Sign Up / Sign In',
                        style: GlobalStyles.secondaryButtonText),
                    onPressed: () {
                      loginFunction(context);
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  FilledButton(
                    style: GlobalStyles.primaryButton,
                    child: const Text('Sign In as Guest',
                        style: GlobalStyles.primaryButtonText),
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
