import 'package:beakpeek/View/Home/Searching/searchbar_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:beakpeek/View/Home/home.dart';
import 'package:beakpeek/Model/nav.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([GoRouter])
void main() {
  group('Home Widget', () {
    testWidgets('renders the Home widget correctly', (tester) async {
      // Create a mock GoRouter

      // Build the Home widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Home(),
        ),
      );

      // Verify the presence of the SearchbarContainer
      expect(find.byType(SearchbarContainer), findsOneWidget);

      // Verify the presence of the quiz section
      expect(find.text('Test Your Knowledge!'), findsOneWidget);
      expect(find.text('Guess the bird from the picture...'), findsOneWidget);
      expect(find.text('Start Quiz'), findsOneWidget);

      // Verify the presence of the achievements section
      expect(find.text('Tracked Achievements'), findsOneWidget);
      expect(find.text('Achievement 1'), findsOneWidget);
      expect(find.text('Achievement 2'), findsOneWidget);

      // Verify the presence of the bird wishlist section
      // expect(find.text('Birds You Want to See'), findsOneWidget);
      // expect(find.text('Brown-Headed Parrot'), findsOneWidget);
      // expect(find.text('Cape Vulture'), findsOneWidget);
      // expect(find.text('Honeyguide'), findsOneWidget);

      // Verify the presence of the BottomNavigation widget
      expect(find.byType(BottomNavigation), findsOneWidget);
    });
  });
}
