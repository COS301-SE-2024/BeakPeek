import 'package:flutter/material.dart';

class CustTextSpan extends StatelessWidget {
  const CustTextSpan({super.key});

  @override
  Widget build(BuildContext context) {
    const TextStyle baseTextStyle = TextStyle(
      color: Color(0xB200383E),
      fontSize: 20,
      fontFamily: 'SF Pro Display',
      fontWeight: FontWeight.w400,
    );

    const TextStyle highlightedTextStyle = TextStyle(
      color: Color(0xFFCE7625),
    );

    return RichText(
      text: const TextSpan(
        style: baseTextStyle,
        children: <TextSpan>[
          TextSpan(
            text: 'Create an account or sign in \nto join the',
          ),
          TextSpan(
            text: ' BeakPeak',
            style: highlightedTextStyle,
          ),
          TextSpan(
            text: ' community.',
          ),
        ],
      ),
    );
  }
}
