import 'package:flutter/material.dart';

void showHelpPopup(BuildContext context, String content) {
  showDialog(
    context: context,
    builder: (context) => _buildHelpDialog(context, content),
  );
}

Widget _buildHelpDialog(BuildContext context, String content) {
  return AlertDialog(
    title: const Text('Help'),
    content: Text(content),
    actions: [
    TextButton(
        child: const Text('Close'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}