import 'package:beakpeek/Controller/DB/database_calls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:localstorage/localstorage.dart';
import 'package:beakpeek/Model/bird.dart';
import 'package:beakpeek/Model/bird_search_functions.dart';
import 'package:beakpeek/Controller/Main/theme_provider.dart';

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

Widget progressBars(List<int> birdNums) {
  return SizedBox(
    height: 200,
    child: ListView.builder(
      itemCount: provinces.length,
      itemBuilder: (context, index) {
        final String prov = provinces[index];
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
              child: Text(
                prov,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            FAProgressBar(
              currentValue: getPercent(birdNums[index], 1000),
              displayText: '%',
              size: 15,
            ),
          ],
        );
      },
    ),
  );
}

double getPercent(int numTotalBirds, int birdsInLife) {
  return ((birdsInLife / numTotalBirds) * 100);
}
