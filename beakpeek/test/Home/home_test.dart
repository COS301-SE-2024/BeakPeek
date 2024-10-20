import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:beakpeek/View/Home/home.dart';
import 'package:beakpeek/Model/Globals/globals.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  // ignore: unused_local_variable
  final MockNavigatorObserver mockNavigatorObserver = MockNavigatorObserver();

  group('Home Widget Unit and Widget Tests ', () {
    test('Test fetching birds with cache', () async {
      final HomeState homeState = HomeState();
      global.cachedBirds = [
        Bird(
          id: 1,
          commonSpecies: 'Sparrow',
          genus: 'Passer',
          species: 'domesticus',
          imageUrl: 'https://example.com/sparrow.png',
          commonGroup: '',
          fullProtocolRR: 0,
          fullProtocolNumber: 1,
          latestFP: '',
          totalRecords: 1,
          reportingRate: 10.0,
        ),
      ];

      final birds = homeState.fetchBirdsWithCache();

      // Assert that the fetched birds are not empty
      expect(birds, isNotNull);

      // Now check that the birds are cached
      expect(global.cachedBirds, isNotNull);
    });

    testWidgets('Test if Home widget renders correctly', (tester) async {
      global.cachedPentadId = Future.value('');
      await tester.pumpWidget(
        const MaterialApp(
          home: Home(),
        ),
      );

      // Test if the "Test Your Knowledge!" text is present
      expect(find.text('Test Your Knowledge!'), findsOneWidget);

      // Test if the "Start Quiz" button is present
      expect(find.text('Start Quiz'), findsOneWidget);
    });

    testWidgets('Test FutureBuilder loading state in Home', (tester) async {
      global.cachedPentadId = Future.value('');
      await tester.pumpWidget(const MaterialApp(home: Home()));

      // Initially, it should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading birds near you...'), findsOneWidget);
    });
  });
}
