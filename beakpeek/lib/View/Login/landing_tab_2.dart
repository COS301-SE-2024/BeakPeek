import 'package:beakpeek/Controller/Azure/login.dart';
import 'package:beakpeek/Styles/colors.dart';
import 'package:beakpeek/View/Login/terms_and_conditions_popup.dart';
import 'package:flutter/material.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:flutter_popup_card/flutter_popup_card.dart';
import 'package:localstorage/localstorage.dart';

class LandingTab2 extends StatelessWidget {
  const LandingTab2({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    void goHome(context) {
      context.goNamed('home');
    }

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
                padding: EdgeInsets.only(top: screenHeight * 0.07),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: const Alignment(-0.6, 0),
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          style: GlobalStyles.mainHeadingPrimary(context),
                          children: [
                            TextSpan(
                                text: 'Explore,\n',
                                style:
                                    GlobalStyles.mainHeadingPrimary(context)),
                            TextSpan(
                              text: 'Discover,\n',
                              style: GlobalStyles.mainHeadingTertiary(context),
                            ),
                            TextSpan(
                                text: 'and Share',
                                style:
                                    GlobalStyles.mainHeadingPrimary(context)),
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
                              text:
                                  'Create an account or sign in \nto join the',
                            ),
                            TextSpan(
                              text: ' BeakPeak',
                              style: TextStyle(
                                color: Color.fromARGB(255, 216, 96, 48),
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
                    SizedBox(height: screenHeight * 0.03),
                    OutlinedButton(
                      style: GlobalStyles.buttonPrimaryFilled(context),
                      child: Text('Sign Up / Sign In',
                          style: GlobalStyles.primaryButtonText(context)),
                      onPressed: () {
                        if (localStorage.getItem('termsAndCondition') ==
                            'true') {
                          loginFunction(context);
                        } else {
                          showPopupCard(
                            dimBackground: true,
                            context: context,
                            builder: (context) {
                              return PopupCard(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: TermsAndConditionsPopup(
                                  login: loginFunction,
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    FilledButton(
                      style: GlobalStyles.buttonPrimaryOutlined(context),
                      child: Text('Sign In as Guest',
                          style: GlobalStyles.secondaryButtonText(context)),
                      onPressed: () {
                        if (localStorage.getItem('termsAndCondition') !=
                            'true') {
                          showPopupCard(
                            dimBackground: true,
                            context: context,
                            builder: (context) {
                              return PopupCard(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: TermsAndConditionsPopup(
                                  login: goHome,
                                ),
                              );
                            },
                          );
                        }
                      },
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
