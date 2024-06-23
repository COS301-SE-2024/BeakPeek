import 'package:beakpeek/View/Home/home.dart';
import 'package:beakpeek/View/Login/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const LandingPage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'home',
          builder: (context, state) {
            return const Home();
          },
        ),
      ],
    ),
  ],
);

class RouterProvider extends StatelessWidget {
  /// Constructs a [MyApp]
  const RouterProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}
