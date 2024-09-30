import 'package:beakpeek/Model/LandingText/signup_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Adjust the import as per your project structure

void main() {
  testWidgets('SignupStack renders correctly', (tester) async {
    // Build the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SignupStack(),
        ),
      ),
    );

    // Verify if the image is present
    final imageFinder = find.byType(Image);
    expect(imageFinder, findsOneWidget);

    final richTextFinder = find.byType(RichText);
    expect(richTextFinder, findsNWidgets(2)); // Expect 2 RichText widgets

    // Extract the first RichText widget to check the "Sign inNow!" TextSpan
    final richText = tester.widget<RichText>(richTextFinder.first);

    // Check the "Sign inNow!" text span properties
    final TextSpan textSpan = richText.text as TextSpan;
    expect(textSpan.text,
        'Sign in'); // The first part of the text should be "Sign in"

    // Check that the second part of the text is "Now!"
    final TextSpan nowTextSpan = textSpan.children![0] as TextSpan;
    expect(nowTextSpan.text, 'Now!');

    // Verify the presence of the "Sign in!" text within the second RichText
    final signInRichText = tester.widget<RichText>(richTextFinder.last);
    final TextSpan signInTextSpan = signInRichText.text as TextSpan;
    expect(signInTextSpan.text, 'Sign in!');
  });
}
