import 'dart:math';
import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:beakpeek/Model/UserProfile/user_model.dart';
import 'package:beakpeek/config_azure.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Controller/DB/database_calls.dart' as db;

const List<String> provinces = [
  'easterncape',
  'gauteng',
  'kwazulu-Natal',
  'limpopo',
  'mpumalanga',
  'northerncape',
  'northwest',
  'westerncape',
  'freestate',
];

ThemeMode getThemeMode(String data) {
  if (data.isEmpty) {
    return ThemeMode.light;
  }
  return ThemeMode.dark;
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

double getPercent(int numTotalBirds, int birdsInLife) {
  if (numTotalBirds == 0) {
    return 1;
  }
  return ((birdsInLife / numTotalBirds) * 100);
}

int getLevelExp() {
  updateLevelStats();
  return user.xp;
}

int getNextLevelExpRequired(int level) {
  final double number = pow((5 * 10), -0.00005) * pow(level, 2) + 100;
  return ((number / 1000.0) * 1000).ceil();
}

double progressPercentage(int progress, int level) {
  return ((progress / getNextLevelExpRequired(level)) * 100);
}

void addExp(int id) async {
  final LifeListProvider lifelist = LifeListProvider.instance;
  final bird = await lifelist.getBirdInByID(id);
  int amount = bird.reportingRate.toInt();
  if (amount <= 1) {
    amount = 100;
  } else {
    amount = 100 - amount;
  }
  final int newExp = amount + user.xp;
  user.xp = newExp;
  updateLevelStats();
}

void updateLevelStats() {
  int expProgress = user.xp;
  int nextLevelEXP = getNextLevelExpRequired(user.level);
  if (nextLevelEXP <= expProgress) {
    user.level = user.level + 1;
    expProgress = expProgress - nextLevelEXP;
    if (expProgress < 0) {
      expProgress = 0;
    }
    user.xp = expProgress;
    nextLevelEXP = getNextLevelExpRequired(user.level);
  }
  storeUserLocally(user);
}

Future<List<int>> countProv() async {
  late final LifeListProvider lifeList = LifeListProvider.instance;
  final List<int> provCount = [0, 0, 0, 0, 0, 0, 0, 0, 0];
  await lifeList.fetchLifeList().then(
    (birds) {
      for (final bird in birds) {
        db.getProvincesForBird(bird.id).then(
          (prov) {
            for (int i = 0; i < prov.length; i++) {
              if (prov[i] == true) {
                provCount[i]++;
              }
            }
          },
        );
      }
    },
  );
  return provCount;
}

int birdexpByRarity(double reportingRate) {
  if (reportingRate == 0) {
    return 100;
  }
  return (reportingRate / 100).ceil();
}

String formatProvinceName(String province) {
  // Split the string by camelCase or lowercase sequences
  final RegExp regex = RegExp(r'([a-z])([A-Z])|([a-z])([A-Z][a-z])');
  final String formatted = province.replaceAllMapped(regex, (match) {
    return '${match.group(1)} ${match.group(2) ?? ''}';
  });

  // Capitalize each word
  List<String> words =
      formatted.split(RegExp(r'(?<=[a-z])(?=[A-Z])|(?<=\S)(?=\s)'));
  words =
      words.map((word) => word[0].toUpperCase() + word.substring(1)).toList();

  return words.join(' ');
}

Future<void> updateUserModel() async {
  late final LifeListProvider lifeList = LifeListProvider.instance;
  final List<Map<String, Object?>> birds = await lifeList.getLifeListForUser();
  user.lifelist = birds.toString();
  storeUserLocally(user);
}
