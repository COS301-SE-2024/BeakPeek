// ignore_for_file: lines_longer_than_80_chars

import 'package:beakpeek/LandingText/cust_buttons.dart';
import 'package:beakpeek/LandingText/cust_rich_text.dart';
import 'package:beakpeek/LandingText/cust_text_span.dart';
import 'package:flutter/material.dart';

class LandingTab2Light extends StatelessWidget {
  const LandingTab2Light({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.up,
          children: [
            Image.asset(
              'assets/images/landing2Resize.png',
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(
              height: 30,
            ),
            const CustButtons('/login', 'Login', Colors.black, Colors.white),
            const SizedBox(
              height: 20,
            ),
            const CustButtons('/signup', 'Sign Up', Colors.white, Colors.black),
            const SizedBox(
              height: 20,
            ),
            const Align(
              alignment: FractionalOffset(0.15, 0.5),
              child: CustTextSpan(),
            ),
            const SizedBox(
              height: 20,
            ),
            const Align(
              alignment: FractionalOffset(0.1, 0.5),
              child: CustRichText(
                'Explore, \nDiscover, \nAnd Share',
                Color.fromARGB(255, 139, 107, 77),
                ta: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
