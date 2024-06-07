// ignore_for_file: lines_longer_than_80_chars

import 'package:beakpeek/LandingText/cust_rich_text.dart';
import 'package:flutter/material.dart';

class LandingTab1 extends StatelessWidget {
  const LandingTab1({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        verticalDirection: VerticalDirection.up,
        children: [
          Image.asset(
            'assets/images/landing1.png',
          ),
          const SizedBox(
            height: 50,
          ),
          const CustRichText(
            'Your Ultimate',
            Color(0xFF033A30),
          ),
          const SizedBox(
            height: 10,
          ),
          const CustRichText(
            'Bird-Watching',
            Color(0xFFECAD31),
          ),
          const SizedBox(
            height: 10,
          ),
          const CustRichText(
            ' Companion ',
            Color(0xFF033A30),
          ),
        ],
      ),
    );
  }
}
