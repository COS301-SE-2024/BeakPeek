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

class CustOutlinedButton extends StatelessWidget {
  // ignore: lines_longer_than_80_chars
  const CustOutlinedButton(this.onclick, this.textD, this.c, this.tc,
      {super.key});

<<<<<<< HEAD
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
=======
  final void Function() onclick;
  final String textD;
  final Color c;
  final Color tc;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth / 3, // Match the parent's width
          child: OutlinedButton(
            onPressed: onclick,
            style: OutlinedButton.styleFrom(
              backgroundColor: c,
              foregroundColor: c,
            ),
            child: Text(
              textD,
              style: TextStyle(
                color: tc,
              ),
            ),
          ),
        );
      },
>>>>>>> 07c3a7f (tests)
    );
  }
}
