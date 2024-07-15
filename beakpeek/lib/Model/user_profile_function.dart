import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:beakpeek/Model/bird.dart';
import 'package:beakpeek/Model/bird_search_functions.dart';
import 'package:beakpeek/Controller/Main/theme_provider.dart';

final birdL = [
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

ThemeMode getThemeMode(String data) {
  if (data.isEmpty) {
    return ThemeMode.light;
  }
  return ThemeMode.dark;
}

ThemeMode changeThemeMode(LocalStorage localStorage) {
  final check = localStorage.getItem('theme') ?? '';
  if (check.isEmpty) {
    localStorage.setItem('theme', 'dark');
    ThemeProvider().setDarkScheme(ThemeProvider().darkScheme);
    return ThemeMode.dark;
  }
  localStorage.setItem('theme', '');
  ThemeProvider().setDarkScheme(ThemeProvider().lightScheme);
  return ThemeMode.light;
}

Widget getIcon(LocalStorage localStorage) {
  final check = localStorage.getItem('theme') ?? '';
  if (check.isEmpty) {
    return const Icon(Icons.dark_mode_outlined);
  }
  return const Icon(Icons.light_mode_outlined);
}

String getLabelIcon(LocalStorage localStorage) {
  final check = localStorage.getItem('theme') ?? '';
  if (check.isEmpty) {
    return 'Dark Mode';
  }
  return 'Light Mode';
}

Widget getLiveList() {
  final List<Widget> items = getWidgetListOfBirds(birdL);
  return Column(
    children: [
      items[0],
      items[1],
    ],
  );
}
