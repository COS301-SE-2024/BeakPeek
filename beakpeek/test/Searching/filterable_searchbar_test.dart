import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:beakpeek/Model/bird.dart';
import 'package:beakpeek/View/Home/Searching/filterable_searchbar.dart';

import 'life_list_provider_test.mocks.dart';

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
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    // Additional setup if needed
  });

  group('Filterable Search bar tests', () {
    final mockLifeListProvider = MockLifeListProvider();

    when(mockLifeListProvider.isDuplicate(any).then((_) async => true));

    // testWidgets('Test display', (tester) async {
    //   final Widget testW = FilterableSearchbar(birds: birdL, sort: 0);
    //   await tester.pumpWidget(
    //     MaterialApp(
    //       home: Scaffold(
    //         body: testW,
    //       ),
    //     ),
    //   );

    //   await tester.pump();
    //   await tester
    //       .pumpAndSettle(const Duration(seconds: 10)); // Adjusted timeout

    //   expect(find.byType(Icon), findsOneWidget);
    //   expect(find.byType(Column), findsOneWidget);
    //   expect(find.byType(Row), findsAtLeast(1));
    //   expect(find.byType(FilledButton), findsAtLeast(2));

    //   await tester.tap(find.text('A-Z'));
    //   await tester.pump();
    //   await tester.pumpAndSettle(const Duration(seconds: 10));

    //   await tester.tap(find.text('Report Rate'));
    //   await tester.pump();
    //   await tester.pumpAndSettle(const Duration(seconds: 10));

    //   await tester.tap(find.byIcon(Icons.search));
    //   await tester.pump();
    //   await tester.pumpAndSettle(const Duration(seconds: 10));

    //   expect(find.byType(SearchAnchor), findsOneWidget);
    //   expect(find.byType(ListTile), findsAtLeast(2));
    //   expect(find.byType(SearchBar), findsOneWidget);

    //   await tester.tap(find.byType(SearchBar));
    //   await tester.pump();
    //   await tester.pumpAndSettle(const Duration(seconds: 5));

    //   await tester.enterText(find.byType(SearchBar), 'h');
    //   await tester.pump();
    //   await tester.pumpAndSettle(const Duration(seconds: 5));

    //   expect(find.byType(ListTile), findsAtLeast(1));
    // });

    testWidgets('Test empty List', (tester) async {
      final List<Bird> empty = [];
      final Widget testW = FilterableSearchbar(birds: empty, sort: 0);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: testW,
          ),
        ),
      );

      await tester.pump(); // Initial pump
      await tester.pumpAndSettle(const Duration(seconds: 5));

      await tester.tap(find.text('Report Rate'));
      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byType(SearchBar), findsOneWidget);

      await tester.enterText(find.byType(SearchBar), 'here');
      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byType(ListTile), findsNothing);
    });
  });
}
