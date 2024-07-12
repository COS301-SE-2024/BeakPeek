import 'package:beakpeek/Model/bird.dart';
import 'package:beakpeek/Model/bird_search_functions.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

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

ThemeMode changeThemeMode() {
  final check = localStorage.getItem('theme') ?? '';
  if (check.isEmpty) {
    localStorage.setItem('theme', 'dark');
    return ThemeMode.dark;
  }
  localStorage.setItem('theme', '');
  return ThemeMode.light;
}

Widget getIcon() {
  final check = localStorage.getItem('theme') ?? '';
  if (check.isEmpty) {
    return const Icon(Icons.dark_mode_outlined);
  }
  return const Icon(Icons.light_mode_outlined);
}

String getLabelIcon() {
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
