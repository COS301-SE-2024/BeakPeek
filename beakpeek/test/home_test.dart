import 'package:beakpeek/Model/nav.dart';
import 'package:beakpeek/View/Home/Searching/searchbar_container.dart';
import 'package:beakpeek/View/Home/home.dart';
import 'package:beakpeek/View/Home/map_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Home widget test',
    () {
      testWidgets('View Map button is displayed', (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
            body: Home(),
          ),
        ));
        expect(find.text('View Map'), findsAtLeast(1));
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
        'Help Icon',
        (tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: Home(),
              ),
            ),
          );
          expect(find.byKey(const Key('helpLogo')), findsAtLeast(1));
        },
      );

      // testWidgets(
      //   'Help Icon tap',
      //   (tester) async {
      //     await tester.pumpWidget(
      //       const MaterialApp(
      //         home: Scaffold(
      //           body: Home(),
      //         ),
      //       ),
      //     );
      //     expect(find.byKey(const Key('helpLogo')), findsAtLeast(1));
      //     await tester.tap(find.byKey(const Key('helpLogo')));
      //     await tester.pumpAndSettle();
      //     expect(find.byType(AlertDialog), findsOne);
      //   },
      // );

      testWidgets(
        'Map button tap',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              onGenerateRoute: (routeSettings) {
                return TestRouting.onGenerateRoute(
                  settings: routeSettings,
                  routeStubbingOptions: {Routing.loginRoute: true},
                );
              },
              home: const Scaffold(
                body: Home(),
              ),
            ),
          );
          await tester.tap(find.byType(FilledButton));
          await tester.pumpAndSettle();

          expect(find.byKey(const Key(Routing.loginRoute)), findsNothing);
        },
      );

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

typedef RouteStubbingOptions = Map<String, bool>;

class TestRouting {
  static PageRoute onGenerateRoute({
    required RouteSettings settings,
    required RouteStubbingOptions routeStubbingOptions,
  }) {
    final routeName = settings.name;
    return MaterialPageRoute(
      builder: (_) {
        final routeStubbingFlag = routeStubbingOptions[routeName] ?? false;

        final Key key = Key(settings.name!);

        return routeStubbingFlag
            ? Placeholder(key: key)
            : Routing.getWidgetOfRoute(settings);
      },
      settings: settings,
    );
  }
}

class Routing {
  static const String loginRoute = '/map';
  static const String homeRoute = '/home';

  static Map<String, Widget Function(RouteSettings)> routeToWidgetMappings = {
    loginRoute: (settings) => const Home(),
    homeRoute: (settings) => const MapInfo(),
  };

  static Widget getWidgetOfRoute(RouteSettings settings) {
    final routeName = settings.name;
    final widgetFunction = routeToWidgetMappings[routeName];
    assert(
      widgetFunction != null,
      "No route to widget mapping found for route \"${settings.name}\", make sure you have registered the widget as you're adding a new route.",
    );
    return widgetFunction!(settings);
  }

  static PageRoute onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => getWidgetOfRoute(settings),
      settings: settings,
    );
  }
}
