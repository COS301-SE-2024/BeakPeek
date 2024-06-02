import 'package:beakpeek/LandingText/nav.dart';
import 'package:beakpeek/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Home widget test', (tester) async {
    // Build our widget
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Home(),
      ),
    ));

    // Verify that the search bar is displayed
    expect(find.byType(TopSearchBar), findsOneWidget);

    // Verify that the "Justin's Bird of the Day" text is displayed
    // expect(find.text('Bird of the Day'), findsOneWidget);

    // Verify that the "Black Fronted Bushsrike" text is displayed
    expect(find.text('Black Fronted Bushsrike'), findsOneWidget);

    // Verify that the "View Map" button is displayed
    expect(find.text('View Map'), findsOneWidget);

    // Verify that the bottom navigation is displayed
    expect(find.byType(BottomNavigation), findsOneWidget);
  });
}

