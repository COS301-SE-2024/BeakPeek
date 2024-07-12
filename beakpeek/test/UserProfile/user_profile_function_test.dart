import 'package:beakpeek/Model/bird.dart';
import 'package:beakpeek/Model/user_profile_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mockito/annotations.dart';

final birds = [
  Bird(
    pentad: '1',
    spp: 1,
    commonGroup: 'Laughing',
    commonSpecies: 'Dove',
    genus: 'genus',
    species: 'species',
    reportingRate: 10.0,
  ),
  Bird(
    pentad: '1',
    spp: 1,
    commonGroup: 'African',
    commonSpecies: 'Eagle',
    genus: 'genus',
    species: 'species',
    reportingRate: 10.0,
  ),
];

@GenerateMocks([LocalStorage])
void main() {
  group(
    'ThemeMode tests',
    () {
      test(
        'getThemeMode returns ThemeMode.light when data is empty',
        () {
          expect(getThemeMode(''), ThemeMode.light);
        },
      );

      test(
        'getThemeMode returns ThemeMode.dark when data is not empty',
        () {
          expect(getThemeMode('data'), ThemeMode.dark);
        },
      );
    },
  );

  // group(
  //   'LocalStorage Tests',
  //   () {
  //     TestWidgetsFlutterBinding.ensureInitialized();
  //     //final MockLocalStorage localStorage = MockLocalStorage();
  //     initLocalStorage();
  //     test(
  //       'changeThemeMode toggles theme correctly',
  //       () async {
  //         //when(localStorage.getItem('theme')).thenReturn('dark');
  //         expect(changeThemeMode(), ThemeMode.dark);
  //         expect(localStorage.getItem('theme'), 'dark');
  //         expect(changeThemeMode(), ThemeMode.light);
  //         expect(localStorage.getItem('theme'), '');
  //       },
  //     );
  //   },
  // );

  // group('Icon tests', () {
  //   test('getIcon returns dark mode icon when theme is light', () {
  //     expect(getIcon(), const Icon(Icons.dark_mode_outlined));
  //   });

  //   test('getIcon returns light mode icon when theme is dark', () {
  //     localStorage.setItem('theme', 'dark');
  //     expect(getIcon(), const Icon(Icons.light_mode_outlined));
  //   });

  //   test('getLabelIcon returns correct label based on theme', () {
  //     expect(getLabelIcon(), 'Dark Mode');
  //     localStorage.setItem('theme', 'dark');
  //     expect(getLabelIcon(), 'Light Mode');
  //   });
  // });

  group('Live List tests', () {
    testWidgets('getLiveList returns correct list of bird widgets',
        (tester) async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: getLiveList())));

      expect(find.text('Laughing Dove'), findsOneWidget);
      expect(find.text('African Eagle'), findsOneWidget);
    });
  });
}
