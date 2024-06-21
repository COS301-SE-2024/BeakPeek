import 'package:beakpeek/Model/bird.dart';
import 'package:beakpeek/View/Home/Searching/filterable_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../analysis_options.yaml';

void main() {
  group(
    'Testing the Filter Buttons and display',
    () {
      testWidgets(
        'Alphabetical sort button is displayed',
        (tester) async {
          list = Bird(
            pentad: 'pentad',
            spp: 1,
            commonGroup: 'commonGroup',
            commonSpecies: 'commonSpecies',
            genus: 'genus',
            species: 'species',
            reportingRate: 20.2,
          );
          await tester.pumpWidget(MaterialApp(
            home: Scaffold(
              body: FilterableSearchbar(
                birds: [list],
                sort: 0,
              ),
            ),
          ));

          expect(find.text('A-Z'), findsOneWidget);
          expect(find.text('ReportRate'), findsOneWidget);
        },
      );
    },
  );
}
