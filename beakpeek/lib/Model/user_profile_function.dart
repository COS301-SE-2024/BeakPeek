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
    reportingRate: 65.0,
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
  Bird(
    pentad: '1',
    spp: 1,
    commonGroup: 'Common',
    commonSpecies: 'Pigeon',
    genus: 'genus',
    species: 'species',
    reportingRate: 85.0,
  ),
  Bird(
    pentad: '1',
    spp: 1,
    commonGroup: 'Ivan',
    commonSpecies: 'Horak',
    genus: 'genus',
    species: 'species',
    reportingRate: 42.0,
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

Widget getLiveList(List<Bird> birds) {
  final List<Widget> items = getWidgetLifeList(birds);
  if (items.isEmpty) {
    return const Text(
      'NO Birds Seen',
      style: TextStyle(color: Colors.black),
    );
  }
  return SizedBox(
    height: 200,
    child: ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return items[index];
      },
    ),
  );
}

List<Widget> getWidgetLifeList(List<Bird> birds) {
  //print(birds);
  final List<Widget> listOfBirdWidgets = [];
  for (var i = 0; i < birds.length; i++) {
    listOfBirdWidgets.add(getLifeListData(birds[i]));
  }
  return listOfBirdWidgets;
}

Widget getLifeListData(Bird bird) {
  return ListTile(
    title: Text(
      bird.commonGroup != 'None'
          ? '${bird.commonGroup} ${bird.commonSpecies}'
          : bird.commonSpecies,
      style: const TextStyle(color: Color.fromARGB(255, 177, 88, 88)),
    ),
    subtitle: Text('Scientific Name: ${bird.genus} ${bird.species}'),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('${bird.reportingRate}%'),
        const SizedBox(width: 8),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorArray[getColorForReportingRate(bird.reportingRate)],
          ),
        ),
      ],
    ),
  );
}

List<Bird> sortAlphabetically(List<Bird> birds) {
  birds.sort((a, b) => a.commonGroup.compareTo(b.commonGroup));
  return birds;
}
