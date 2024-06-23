import 'package:beakpeek/Model/help_icon_model_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Help icons Test',
    () {
      testWidgets(
        'me testing',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (context) {
                    return buildHelpDialog(context, '');
                  },
                ),
              ),
            ),
          );

          expect(find.byType(AlertDialog), findsOne);
        },
      );
    },


    testWidgets(
        'me testing',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (context) {
                    return buildHelpDialog(context, '');
                  },
                ),
              ),
            ),
          );

          expect(find.byType(AlertDialog), findsOne);
        },
      );
  );
}
