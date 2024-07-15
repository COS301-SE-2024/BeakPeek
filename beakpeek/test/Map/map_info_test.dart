import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:beakpeek/View/Home/bird_map.dart';
import 'package:beakpeek/Model/top_search_bar.dart';
import 'package:beakpeek/Model/nav.dart';
import 'package:beakpeek/View/Home/map_info.dart';

void main() {
  testWidgets('MapInfo widget test', (tester) async {
    // Build the MyApp widget
    await tester.pumpWidget(
      const MaterialApp(
        home: MapInfo(),
      ),
    );

    // Verify TopSearchBar is present
    expect(find.byType(TopSearchBar), findsOneWidget);

    // Verify RichText with specific content is present
    expect(find.byType(RichText), findsAtLeast(1));

    // Verify GestureDetector with Icon is present
    expect(find.byType(GestureDetector), findsAtLeast(1));
    expect(
        find.byIcon(const IconData(0xe309,
            fontFamily: 'MaterialIcons', matchTextDirection: true)),
        findsOneWidget);

    // Tap the Icon to show the help popup
    await tester.tap(find.byIcon(const IconData(0xe309,
        fontFamily: 'MaterialIcons', matchTextDirection: true)));
    await tester.pumpAndSettle();

    // Verify help popup content
    expect(find.textContaining('This map shows you your current location.'),
        findsOneWidget);

    // Close the help popup
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    // Verify BirdMap is present
    expect(find.byType(BirdMap), findsOneWidget);

    // Verify BottomNavigation is present
    expect(find.byType(BottomNavigation), findsOneWidget);
  });
}
