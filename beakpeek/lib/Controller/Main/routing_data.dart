import 'package:beakpeek/Model/bird.dart';
import 'package:beakpeek/View/Home/bird_page.dart';
import 'package:beakpeek/View/Home/home.dart';
import 'package:beakpeek/View/Home/map_info.dart';
import 'package:beakpeek/View/Login/landing_page.dart';
import 'package:beakpeek/View/UserProfile/user_profile.dart';
import 'package:go_router/go_router.dart';

class RoutingData {
  final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/map',
        builder: (context, state) {
          return const MapInfo();
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) {
          return const UserProfile();
        },
      ),
      // GoRoute(
      //   path: '/bird/:bird',
      //   builder: (context, state) {
      //     final Bird id = state.pathParameters['bird'];
      //     return BirdPage(bird: id);
      //   },
      // ),
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
}
