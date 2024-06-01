import 'package:flutter/material.dart';

class CustButtons extends StatelessWidget {
  const CustButtons(this.path, this.textD, this.c, this.tc, {super.key});

  final String path;
  final String textD;
  final Color c;
  final Color tc;
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        Navigator.pushNamed(context, path);
      },
      style: FilledButton.styleFrom(
        backgroundColor: c,
        minimumSize: const Size(350, 50),
        shadowColor: Colors.black,
      ),
      child: Text(
        textD,
        style: TextStyle(
          color: tc,
        ),
      ),
    );
  }
}
