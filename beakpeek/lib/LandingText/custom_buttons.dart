// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  const CustomFilledButton({
    required this.routePath,
    required this.buttonText,
    required this.backgroundColor,
    required this.textColor,
    super.key,
  });

  final String routePath;
  final String buttonText;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        Navigator.pushNamed(context, routePath);
      },
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: const Size(350, 50),
        shadowColor: Colors.black,
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          color: textColor,
        ),
      ),
    );
  }
}

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({
    required this.routePath,
    required this.buttonText,
    required this.backgroundColor,
    required this.textColor,
    super.key,
  });

  final String routePath;
  final String buttonText;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        Navigator.pushNamed(context, routePath);
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: backgroundColor),
        backgroundColor: Colors.transparent,
        minimumSize: const Size(350, 50),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          color: textColor,
        ),
      ),
    );
  }
}
