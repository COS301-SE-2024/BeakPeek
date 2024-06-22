import 'package:beakpeek/Model/bird.dart';
import 'package:beakpeek/View/Home/Searching/searchbar_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

@GenerateMocks([http.Client])
void main() {
  group(
    'Search Container',
    () {
      testWidgets(
        'Featch All Birds Function Test',
        (tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: SearchbarContainer(),
              ),
            ),
          );

          expect(find.byType(Column), findsAtLeast(1));
          expect(find.byType(FutureBuilder<List<Bird>>), findsOne);
        },
      );
    },
  );
}
