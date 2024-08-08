import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:beakpeek/View/Map/bird_map.dart';
import 'package:beakpeek/Model/nav.dart';
import 'package:beakpeek/View/Map/map_info.dart';

void main() {
  testWidgets('MapInfo widget test', (tester) async {
    // Build the MyApp widget
    await tester.pumpWidget(
      const MaterialApp(
        home: MapInfo(),
      ),
    );

    // Verify TopSearchBar is present
    expect(find.byType(BottomNavigation), findsOneWidget);

    // Verify RichText with specific content is present
    expect(find.byType(RichText), findsAtLeast(1));

    // Verify GestureDetector with Icon is present
    expect(find.byType(GestureDetector), findsAtLeast(1));

    // Verify BirdMap is present
    expect(find.byType(BirdMap), findsOneWidget);
  });
}
