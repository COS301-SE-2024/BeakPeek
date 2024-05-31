import 'package:flutter/material.dart';

class CustRichText extends StatelessWidget {
  const CustRichText(this.textD, this.c, {super.key});

  final String textD;
  final Color c;
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: textD,
        style: TextStyle(
          color: c,
          fontSize: 40,
          fontFamily: 'SF Pro Display',
          fontWeight: FontWeight.w600,
          height: 0,
        ),
      ),
    );
  }
}
