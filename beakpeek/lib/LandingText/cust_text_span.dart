import 'package:flutter/material.dart';

class CustTextSpan extends StatelessWidget {
  const CustTextSpan({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        text: 'Create an account or sign in \nto join the',
        style: TextStyle(
          color: Color(0xB200383E),
          fontSize: 20,
          fontFamily: 'SF Pro Display',
          fontWeight: FontWeight.w400,
          height: 0,
        ),
        children: <TextSpan>[
          TextSpan(
            text: ' BeakPeak',
            style: TextStyle(
              color: Color(0xFFCE7625),
              fontSize: 20,
              fontFamily: 'SF Pro Display',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
          TextSpan(
            text: ' community.',
            style: TextStyle(
              color: Color(0xB200383E),
              fontSize: 20,
              fontFamily: 'SF Pro Display',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
        ],
      ),
    );
  }
}
