import 'package:beakpeek/View/Achievements/achievements_page.dart';
import 'package:beakpeek/View/Bird/bird_page.dart';
import 'package:beakpeek/View/Home/home.dart';
import 'package:beakpeek/View/Map/heat_map_info.dart';

import 'package:beakpeek/View/Map/map_info.dart';
import 'package:beakpeek/View/Login/landing_page.dart';
import 'package:beakpeek/View/Quiz/bird_quiz.dart';
import 'package:beakpeek/View/Settings/settings_page.dart';
import 'package:beakpeek/View/Sightings/sightings.dart';
import 'package:beakpeek/View/Settings/edit_user_profile.dart';
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
              child: Text('Home ${ModalRoute.of(context)?.settings.name}'),
            ),
          ),
        )),
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) {
          return const LandingPage();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'home',
            name: 'home',
            builder: (context, state) {
              return const Home();
            },
            routes: <RouteBase>[
              GoRoute(
                path: 'heatmap/:id',
                name: 'heatmap',
                builder: (context, state) {
                  return HeatMapInfo(
                    id: int.parse(state.pathParameters['id']!),
                  );
                },
              ),
              GoRoute(
                path: 'bird/:group/:species/:id',
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
                path: 'map',
                name: 'map',
                builder: (context, state) {
                  return const MapInfo();
                },
              ),
              GoRoute(
                path: 'profile',
                name: 'profile',
                builder: (context, state) {
                  return const UserProfile();
                },
                routes: <RouteBase>[
                  GoRoute(
                    path: 'settings',
                    name: 'settings',
                    builder: (context, state) {
                      return SettingsPage();
                    },
                    routes: <RouteBase>[
                      GoRoute(
                        path: 'editprofile',
                        name: 'editprofile',
                        builder: (context, state) {
                          return const EditUserProfile();
                        },
                      ),
                    ],
                  ),
                ],
              ),
              GoRoute(
                path: 'sightings',
                name: 'sightings',
                builder: (context, state) {
                  return const Sightings();
                },
              ),
              GoRoute(
                path: 'quiz',
                name: 'quiz',
                builder: (context, state) {
                  return const BirdQuiz();
                },
              ),
              GoRoute(
                path: 'achievements',
                name: 'achievements',
                builder: (context, state) {
                  return const AchievementsPage();
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
