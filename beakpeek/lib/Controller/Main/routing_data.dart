import 'package:beakpeek/View/Bird/bird_page.dart';
import 'package:beakpeek/View/Home/home.dart';
import 'package:beakpeek/View/Map/heat_map_info.dart';

import 'package:beakpeek/View/Map/map_info.dart';
import 'package:beakpeek/View/Login/landing_page.dart';
import 'package:beakpeek/View/Quiz/bird_quiz.dart';
import 'package:beakpeek/View/Sightings/sightings.dart';
import 'package:beakpeek/View/UserProfile/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// ignore: unused_import
import 'package:localstorage/localstorage.dart';

class RoutingData {
  final GoRouter router = GoRouter(
    errorBuilder: ((context, state) => Scaffold(
          body: Center(
            child: FilledButton(
              onPressed: () => context.go('/home'),
              child: const Text('Home'),
            ),
          ),
        )),
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
      GoRoute(
        path: '/sightings',
        builder: (context, state) {
          return const Sightings();
        },
      ),
      GoRoute(
        path: '/quiz',
        builder: (context, state) {
          return const BirdQuiz();
        },
      ),
      GoRoute(
        path: '/bird/:group/:species/:id',
        name: 'birdInfo',
        builder: (context, state) {
          return BirdPage(
            commonGroup: state.pathParameters['group']!,
            commonSpecies: state.pathParameters['species']!,
            id: int.parse(state.pathParameters['id']!),
          );
        },
      ),
      GoRoute(
        path: '/heatmap/:id',
        name: 'HeatMap',
        builder: (context, state) {
          return HeatMapInfo(
            id: int.parse(state.pathParameters['id']!),
          );
        },
      ),
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
