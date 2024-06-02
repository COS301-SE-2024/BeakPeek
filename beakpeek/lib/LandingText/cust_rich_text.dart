import 'package:flutter/material.dart';

class CustRichText extends StatelessWidget {
  const CustRichText(this.textD, this.c,
      {this.ta = TextAlign.center, this.fontS = 40, super.key});

  final String textD;
  final Color c;
  final TextAlign ta;
  final double fontS;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: textD,
        style: TextStyle(
          color: c,
          fontSize: fontS,
          fontFamily: 'SF Pro Display',
          fontWeight: FontWeight.w600,
          height: 0,
        ),
      ),
      textAlign: ta,
    );
  }
}
