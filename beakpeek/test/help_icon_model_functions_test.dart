import 'package:beakpeek/Model/help_icon_model_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Help icons Test',
    () {
      testWidgets(
        'help testing',
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
  );

  testWidgets('showHelpPopup displays help dialog with correct content',
      (tester) async {
    // Define the test key
    const testKey = Key('testKey');

    // Build a simple app with a button that triggers the showHelpPopup function
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                key: testKey,
                onPressed: () {
                  showHelpPopup(context, 'Test Help Content');
                },
                child: const Text('Show Help'),
              );
            },
          ),
        ),
      ),
    );

    // Tap the button to trigger the dialog
    await tester.tap(find.byKey(testKey));
    await tester.pumpAndSettle(); // Wait for the dialog to appear

    // Verify if the dialog appears with the correct content
    expect(find.text('Help'), findsOneWidget);
    expect(find.text('Test Help Content'), findsOneWidget);
    expect(find.text('Close'), findsOneWidget);

    // Tap the 'Close' button to close the dialog
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle(); // Wait for the dialog to disappear

    // Verify if the dialog is closed
    expect(find.text('Help'), findsNothing);
    expect(find.text('Test Help Content'), findsNothing);
  });
}
