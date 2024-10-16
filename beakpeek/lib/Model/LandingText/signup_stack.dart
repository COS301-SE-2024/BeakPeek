import 'package:flutter/material.dart';

class SignupStack extends StatelessWidget {
  const SignupStack({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Image.asset(
            'assets/images/logIn.png',
            fit: BoxFit.fitWidth,
          ),
        ),
        Align(
          heightFactor: 2,
          alignment: const FractionalOffset(0.9, 1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: const TextSpan(
                  text: 'Sign in',
                  style: TextStyle(
                    color: Color(0xFFF97142),
                    fontSize: 36,
                  ),
                  children: [
                    TextSpan(
                      text: 'Now!',
                      style: TextStyle(
                        color: Color(0xFF00383E),
                        fontSize: 36,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Align(
          heightFactor: 10.3,
          alignment: const FractionalOffset(0.1, 1),
          child: RichText(
            text: const TextSpan(
              text: 'Sign in!',
              style: TextStyle(
                color: Color(0xFF00383E),
                fontSize: 36,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
