// ignore_for_file: unused_import

import 'package:beakpeek/Controller/Main/routing_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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

void main() {
  // testWidgets('Initial route should be LandingPage', (tester) async {
  //   final routingData = RoutingData();
  //   await tester.pumpWidget(
  //     MaterialApp.router(
  //       routerDelegate: routingData.router.routerDelegate,
  //       routeInformationParser: routingData.router.routeInformationParser,
  //     ),
  //   );

  //   expect(find.byType(LandingPage), findsOneWidget);
  // });

  // testWidgets('Navigating to Home route', (tester) async {
  //   final routingData = RoutingData();

  //   await tester.pumpWidget(
  //     MaterialApp.router(
  //       routerDelegate: routingData.router.routerDelegate,
  //       routeInformationParser: routingData.router.routeInformationParser,
  //     ),
  //   );

  //   // Simulate navigation to the home route
  //   routingData.router.go('/home');
  //   await tester.pumpAndSettle();

  //   expect(find.byType(Home), findsOneWidget);
  // });

  // testWidgets('Navigating to BirdPage with ID', (tester) async {
  //   final routingData = RoutingData();

  //   await tester.pumpWidget(
  //     MaterialApp.router(
  //       routerDelegate: routingData.router.routerDelegate,
  //       routeInformationParser: routingData.router.routeInformationParser,
  //     ),
  //   );

  //   // Simulate navigation to a bird info page
  //   routingData.router.go('/home/bird/1');
  //   await tester.pumpAndSettle();

  //   expect(find.byType(BirdPage), findsOneWidget);
  // });

  // testWidgets('Navigating to HeatMapInfo with pentadID', (tester) async {
  //   final routingData = RoutingData();

  //   await tester.pumpWidget(
  //     MaterialApp.router(
  //       routerDelegate: routingData.router.routerDelegate,
  //       routeInformationParser: routingData.router.routeInformationParser,
  //     ),
  //   );

  //   // Simulate navigation to a heat map info page
  //   routingData.router.go('/home/heatmap/123');
  //   await tester.pumpAndSettle();

  //   expect(find.byType(HeatMapInfo), findsOneWidget);
  // });

  // testWidgets('Navigating to MapInfo', (tester) async {
  //   final routingData = RoutingData();

  //   await tester.pumpWidget(
  //     MaterialApp.router(
  //       routerDelegate: routingData.router.routerDelegate,
  //       routeInformationParser: routingData.router.routeInformationParser,
  //     ),
  //   );

  //   // Simulate navigation to the map info page
  //   routingData.router.go('/home/map');
  //   await tester.pumpAndSettle();

  //   expect(find.byType(MapInfo), findsOneWidget);
  // });

  // testWidgets('Navigating to UserProfile', (tester) async {
  //   final routingData = RoutingData();

  //   await tester.pumpWidget(
  //     MaterialApp.router(
  //       routerDelegate: routingData.router.routerDelegate,
  //       routeInformationParser: routingData.router.routeInformationParser,
  //     ),
  //   );

  //   // Simulate navigation to the user profile page
  //   routingData.router.go('/home/profile');
  //   await tester.pumpAndSettle();

  //   expect(find.byType(UserProfile), findsOneWidget);
  // });

  // testWidgets('Navigating to SettingsPage', (tester) async {
  //   final routingData = RoutingData();

  //   await tester.pumpWidget(
  //     MaterialApp.router(
  //       routerDelegate: routingData.router.routerDelegate,
  //       routeInformationParser: routingData.router.routeInformationParser,
  //     ),
  //   );

  //   // Simulate navigation to the settings page
  //   routingData.router.go('/home/profile/settings');
  //   await tester.pumpAndSettle();

  //   expect(find.byType(SettingsPage), findsOneWidget);
  // });

  // testWidgets('Navigating to EditUserProfile', (tester) async {
  //   final routingData = RoutingData();

  //   await tester.pumpWidget(
  //     MaterialApp.router(
  //       routerDelegate: routingData.router.routerDelegate,
  //       routeInformationParser: routingData.router.routeInformationParser,
  //     ),
  //   );

  //   // Simulate navigation to edit user profile
  //   routingData.router.go('/home/profile/editprofile');
  //   await tester.pumpAndSettle();

  //   expect(find.byType(EditUserProfile), findsOneWidget);
  // });

  // testWidgets('Navigating to Sightings', (tester) async {
  //   final routingData = RoutingData();

  //   await tester.pumpWidget(
  //     MaterialApp.router(
  //       routerDelegate: routingData.router.routerDelegate,
  //       routeInformationParser: routingData.router.routeInformationParser,
  //     ),
  //   );

  //   // Simulate navigation to sightings
  //   routingData.router.go('/home/sightings');
  //   await tester.pumpAndSettle();

  //   expect(find.byType(Sightings), findsOneWidget);
  // });

  // testWidgets('Navigating to BirdQuiz', (tester) async {
  //   final routingData = RoutingData();

  //   await tester.pumpWidget(
  //     MaterialApp.router(
  //       routerDelegate: routingData.router.routerDelegate,
  //       routeInformationParser: routingData.router.routeInformationParser,
  //     ),
  //   );

  //   // Simulate navigation to the quiz
  //   routingData.router.go('/home/quiz');
  //   await tester.pumpAndSettle();

  //   expect(find.byType(BirdQuiz), findsOneWidget);
  // });

  // testWidgets('Navigating to AchievementsPage', (tester) async {
  //   final routingData = RoutingData();

  //   await tester.pumpWidget(
  //     MaterialApp.router(
  //       routerDelegate: routingData.router.routerDelegate,
  //       routeInformationParser: routingData.router.routeInformationParser,
  //     ),
  //   );

  //   // Simulate navigation to achievements
  //   routingData.router.go('/home/achievements');
  //   await tester.pumpAndSettle();

  //   expect(find.byType(AchievementsPage), findsOneWidget);
  // });
}
