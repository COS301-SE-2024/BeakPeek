import 'package:flutter/material.dart';
import 'package:beakpeek/Styles/custom_text_span.dart';
import 'package:beakpeek/Styles/global_styles.dart';

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
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment(-0.5, 0.0),
                    child: CustTextSpan(),
                  ),
                  const Spacer(flex: 3),
                  OutlinedButton(
                    style: GlobalStyles.secondaryButton,
                    child: const Text('Sign In as Guest',
                        style: GlobalStyles.secondaryButtonText),
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    style: GlobalStyles.primaryButton,
                    child: const Text('Sign Up / Sign In',
                        style: GlobalStyles.primaryButtonText),
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
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
