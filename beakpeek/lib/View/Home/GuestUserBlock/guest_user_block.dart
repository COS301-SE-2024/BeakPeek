import 'package:beakpeek/Styles/global_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GuestUserBlock extends StatelessWidget {
  const GuestUserBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'You need to be logged in!',
            style: GlobalStyles.smallHeadingPrimary(context),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            'Please log in or create an account.',
            style: GlobalStyles.contentPrimary(context),
          ),
          SizedBox(height: screenHeight * 0.02),
          SizedBox(
            width: screenWidth * 0.7,
            child: OutlinedButton(
              style: GlobalStyles.buttonPrimaryFilled(context),
              child: Text('Sign Up / Sign In',
                  style: GlobalStyles.primaryButtonText(context)),
              onPressed: () {
                context.go('/');
              },
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          SizedBox(
            width: screenWidth * 0.7,
            child: FilledButton(
              style: GlobalStyles.buttonPrimaryOutlined(context),
              child: Text('Continue as Guest',
                  style: GlobalStyles.secondaryButtonText(context)),
              onPressed: () {
                context.goNamed('home');
              },
            ),
          ),
        ],
      ),
    );
  }
}
