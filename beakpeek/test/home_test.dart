import 'package:beakpeek/Model/nav.dart';
import 'package:beakpeek/View/Home/Searching/searchbar_container.dart';
//import 'package:beakpeek/Model/top_search_bar.dart';
import 'package:beakpeek/View/Home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Home widget test', () {
    testWidgets('View Map button is displayed', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: Home(),
        ),
      ));
      expect(find.text('View Map'), findsOneWidget);
    });
    testWidgets('Bottom navigation is displayed', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: Home(),
        ),
      ));
      expect(find.byType(BottomNavigation), findsOneWidget);
    });

    testWidgets(
      'Search is displayed',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Home(),
            ),
          ),
        );
        expect(find.byType(SearchbarContainer), findsOneWidget);
      },
    );
    },
  );
}
