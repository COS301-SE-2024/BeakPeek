import 'package:beakpeek/View/Home/Searching/searchbar_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:beakpeek/View/Home/home.dart';
import 'package:beakpeek/Model/nav.dart';

void main() {
  testWidgets('Home widget displays all sections correctly', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Home()));

    // Verify that the SearchbarContainer is present
    expect(find.byType(SearchbarContainer), findsOneWidget);

    // Verify that the Quiz section is present
    expect(find.text('Test Your Knowledge!'), findsOneWidget);
    expect(find.text('Guess the bird from the picture...'), findsOneWidget);
    expect(find.text('Start Quiz'), findsOneWidget);

    // Verify that the Achievements section is present
    expect(find.text('Tracked Achievements'), findsOneWidget);
    expect(find.text('Achievement 1'), findsOneWidget);
    expect(find.text('Achievement 2'), findsOneWidget);

    // Verify that the Bird Wishlist section is present
    expect(find.text('Birds You Want to See'), findsOneWidget);
    expect(find.text('Brown-Headed Parrot'), findsOneWidget);
    expect(find.text('Cape Vulture'), findsOneWidget);
    expect(find.text('Honeyguide'), findsOneWidget);

    // Verify that the BottomNavigation is present
    expect(find.byType(BottomNavigation), findsOneWidget);
  });

  testWidgets('Start Quiz button can be tapped', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Home()));

    // Tap the "Start Quiz" button
    await tester.tap(find.text('Start Quiz'));
    await tester.pump();

    // Verify some expected behavior here, e.g., navigation or showing a quiz
    // screen
    // This part is dependent on the actual functionality you want to test
  });
}
