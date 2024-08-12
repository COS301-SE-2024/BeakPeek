import 'dart:math';
import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:http/http.dart';
import 'package:localstorage/localstorage.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Controller/Main/theme_provider.dart';
import 'package:beakpeek/Controller/DB/database_calls.dart' as db;

const List<String> provinces = [
  'easterncape',
  'freestate',
  'gauteng',
  'kwazulunatal',
  'limpopo',
  'mpumalanga',
  'northerncape',
  'northwest',
  'westerncape'
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

List<Bird> sortAlphabetically(List<Bird> birds) {
  birds.sort((a, b) => a.commonGroup.compareTo(b.commonGroup));
  return birds;
}

Widget progressBars(List<int> birdNumsTotal, List<int> numbirdsInLIfe) {
  return SingleChildScrollView(
    child: SizedBox(
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
                currentValue:
                    getPercent(birdNumsTotal[index], numbirdsInLIfe[index]),
                // displayText: '%',
                size: 10,
              ),
            ],
          );
        },
      ),
    ),
  );
}

double getPercent(int numTotalBirds, int birdsInLife) {
  if (numTotalBirds == 0) {
    return 1;
  }
  return ((birdsInLife / numTotalBirds) * 100);
}

Widget levelProgressBar(int progress, int level) {
  return FAProgressBar(
    currentValue: progressPercentage(progress, level),
    // displayText: '%',
    size: 15,
  );
}

int getLevelExp() {
  updateLevelStats();
  return int.parse(localStorage.getItem('userExp') ?? '0');
}

int getNextLevelExpRequired(int level) {
  final double number = pow((5 * level), 2) + 100;
  return ((number / 1000.0) * 1000).ceil();
}

double progressPercentage(int progress, int level) {
  return ((progress / getNextLevelExpRequired(level)) * 100);
}

void addExp(int amount) {
  final String exp = localStorage.getItem('userExp') ?? '0';
  final int newExp = amount + int.parse(exp);
  localStorage.setItem('userExp', newExp.toString());
  updateLevelStats();
}

void updateLevelStats() {
  final String exp = localStorage.getItem('userExp') ?? '0';
  final String lvl = localStorage.getItem('level') ?? '0';
  int expProgress = int.parse(exp);
  int nextLevelEXP = getNextLevelExpRequired(int.parse(lvl));
  while (nextLevelEXP <= expProgress) {
    final int level = int.parse(lvl) + 1;
    localStorage.setItem('level', level.toString());
    expProgress = expProgress - nextLevelEXP;
    if (expProgress < 0) {
      expProgress = 0;
    }
    localStorage.setItem('userExp', expProgress.toString());
    nextLevelEXP = getNextLevelExpRequired(level);
  }
}

Widget getNumBirdsInProvAndLifeList(
    List<int> birdNumsTotal, Future<List<Bird>> birds) {
  return FutureBuilder<List<Bird>>(
    future: birds,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      return Column(children: [
        Text(birdNumsTotal.toString()),
        Text(
          snapshot.data!.toString(),
        )
      ]);
    },
  );
}

Future<List<int>> countProv() async {
  late final LifeListProvider lifeList = LifeListProvider.instance;
  final List<int> provCount = [0, 0, 0, 0, 0, 0, 0, 0, 0];
  lifeList.fetchLifeList().then(
    (birds) {
      for (final bird in birds) {
        if (bird.commonGroup.isNotEmpty && bird.commonSpecies.isNotEmpty) {
          try {
            db
                .getProvincesBirdIsIn(
                    Client(), bird.commonSpecies, bird.commonGroup)
                .then((prov) {
              for (int i = 0; i < provinces.length; i++) {
                if (prov.length > i && checkProv(prov[i])) {
                  provCount[i]++;
                }
              }
            });
          } catch (error) {
            // ignore: avoid_print
            print('error');
          }
        }
      }
    },
  );

  return provCount;
}

bool checkProv(String prov) {
  if (provinces.contains(prov)) {
    return true;
  } else {
    return false;
  }
}
