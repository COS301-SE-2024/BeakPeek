import 'package:beakpeek/Model/bird.dart';
import 'package:beakpeek/View/Home/Searching/filterable_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final birdL = [
  Bird(
    pentad: '1',
    spp: 1,
    commonGroup: 'here',
    commonSpecies: 'here',
    genus: 'genus',
    species: 'species',
    reportingRate: 10.0,
  ),
  Bird(
    pentad: '1',
    spp: 1,
    commonGroup: 'commonGroup',
    commonSpecies: 'commonSpecies',
    genus: 'genus',
    species: 'species',
    reportingRate: 10.0,
  ),
];

void main() {
  group(
    'Filterable Search bar tests',
    () {
      testWidgets(
        'Test display',
        (tester) async {
          final Widget testW = FilterableSearchbar(birds: birdL, sort: 0);
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: testW,
              ),
            ),
          );
          expect(find.byType(Icon), findsOneWidget);
          expect(find.byType(Column), findsOneWidget);
          expect(find.byType(Row), findsAtLeast(1));
          expect(find.byType(FilledButton), findsAtLeast(2));
          await tester.tap(find.text('A-Z'));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Report Rate'));
          await tester.pumpAndSettle();
          await tester.tap(find.byIcon(Icons.search));
          await tester.pumpAndSettle();
          expect(find.byType(SearchAnchor), findsOne);
          expect(find.byType(ListTile), findsAtLeast(2));
          expect(find.byType(SearchBar), findsOne);
          await tester.tap(find.byType(SearchBar));
          await tester.pumpAndSettle();
          await tester.enterText(find.byType(SearchBar), 'h');
          await tester.pump(Durations.short2);
          expect(find.byType(ListTile), findsAtLeast(1));
        },
      );

      testWidgets(
        'Test empty List',
        (tester) async {
          final List<Bird> empty = [];
          final Widget testW = FilterableSearchbar(birds: empty, sort: 0);
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: testW,
              ),
            ),
          );
          await tester.tap(find.text('Report Rate'));
          await tester.pumpAndSettle();
          await tester.tap(find.byIcon(Icons.search));
          await tester.pumpAndSettle();
          expect(find.byType(SearchBar), findsOne);
          await tester.enterText(find.byType(SearchBar), 'here');
          await tester.pumpAndSettle();
          expect(find.byType(ListTile), findsNothing);
        },
      );
    },
  );
}
