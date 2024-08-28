import 'package:beakpeek/Styles/colors.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:flutter/material.dart';

void showHelpPopup(BuildContext context, String content) {
  showDialog(
    context: context,
    builder: (context) => buildHelpDialog(context, content),
  );
}

Widget buildHelpDialog(BuildContext context, String content) {
  return AlertDialog(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    title: const Text(
      'Help',
      style: TextStyle(color: AppColors.tertiaryColorLight),
    ),
    content: Text(
      content,
      style: const TextStyle(color: Colors.black),
    ),
    actions: [
      TextButton(
        child: const Text(
          'Close',
          style: TextStyle(color: AppColors.tertiaryColorLight),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}
