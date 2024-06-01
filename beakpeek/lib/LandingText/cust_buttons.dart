import 'package:flutter/material.dart';

class CustButtons extends StatelessWidget {
  const CustButtons(this.onclick, this.textD, this.c, this.tc, {super.key});

  final void Function() onclick;
  final String textD;
  final Color c;
  final Color tc;
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onclick,
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

class CustOutlinedButton extends StatelessWidget {
  const CustOutlinedButton(this.onclick, this.textD, this.c, this.tc, {super.key});

  final void Function() onclick;
  final String textD;
  final Color c;
  final Color tc;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth/3, // Match the parent's width
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
    );
  }
}
