import 'package:flutter/material.dart';

void showHelpPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context, String content) {
      return AlertDialog(
        title: Text('Help'),
        content: Text(content),
        actions: [
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}