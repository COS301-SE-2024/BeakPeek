import 'package:beakpeek/Model/LandingText/login_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart'; // Adjust the import as per your project structure

void main() {
  testWidgets('LoginStack renders correctly', (tester) async {
    // Build the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LoginStack(),
        ),
      ),
    );

    // Verify if the image is present
    final imageFinder = find.byType(Image);
    expect(imageFinder, findsOneWidget);

    final richTextFinder = find.byType(RichText);
    expect(richTextFinder, findsNWidgets(2));

    // Extract the first RichText widget to check the "WelcomeBack" TextSpan
    final richText = tester.widget<RichText>(richTextFinder.first);

    // Check the "WelcomeBack" text span properties
    final TextSpan textSpan = richText.text as TextSpan;
    expect(textSpan.text,
        'Welcome'); // The first part of the text should be "Welcome"

    // Check that the second part of the text is "Back!"
    final TextSpan backTextSpan = textSpan.children![0] as TextSpan;
    expect(backTextSpan.text, 'Back!');

    // Verify the presence of the "Sign in!" text within the second RichText
    final signInRichText = tester.widget<RichText>(richTextFinder.last);
    final TextSpan signInTextSpan = signInRichText.text as TextSpan;
    expect(signInTextSpan.text, 'Sign in!');
  });
}
