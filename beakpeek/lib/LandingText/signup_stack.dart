import 'package:beakpeek/LandingText/cust_rich_text.dart';
import 'package:flutter/material.dart';

class LoginStack extends StatelessWidget {
  const LoginStack({super.key});

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
        const Align(
          heightFactor: 2,
          alignment: FractionalOffset(0.9, 1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustRichText(
                'Sign in',
                Color(0xFFF97142),
                fontS: 36,
              ),
              CustRichText(
                'now!',
                Color(0xFF00383E),
                fontS: 36,
              ),
            ],
          ),
        ),
        const Align(
          heightFactor: 10.3,
          alignment: FractionalOffset(0.1, 1),
          child: CustRichText(
            'Sign in!',
            Color(0xFF00383E),
            fontS: 36,
          ),
        ),
      ],
    );
  }
}
