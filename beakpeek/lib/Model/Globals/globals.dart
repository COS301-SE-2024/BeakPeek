library global;

import 'dart:io';

import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:beakpeek/Controller/Home/search.dart';
import 'package:beakpeek/Controller/Main/color_palette_functions.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Model/UserProfile/achievment_list.dart';
import 'package:localstorage/localstorage.dart';

Globals global = Globals();

class Globals {
  final LifeListProvider lifeList = LifeListProvider.instance;
  late List<Bird> birdList = [];
  late List<Bird> allBirdsList = [];
  String? cachedPentadId;
  List<Bird>? cachedBirds;
  ColorPalette palette = greenRedPalette;

  void init() {
    lifeList.fetchLifeList().then((result) {
      birdList = result;
    });
    listBirdFromAssets().then((result) {
      allBirdsList = result;
      lifeList.initialInsert(result);
      lifeList.initialProvInsert(result);
    });
    //lifeList.deleteDatabaseFile();
  }

  Future<List<Bird>> updateLife() async {
    return birdList = await lifeList.fetchLifeList();
  }

  Bird getDefualtBirdData(int id) {
    return allBirdsList.firstWhere((bird) => bird.id == id);
  }

  void getAchievments() {
    getAchivementList().then(
      (result) {
        for (int i = 0; i < result.achievements.length; i++) {
          if (localStorage.getItem(result.achievements[i].name) != null) {
            final double localProgress = double.parse(
                localStorage.getItem(result.achievements[i].name)!);

            if (result.achievements[i].progress > localProgress) {
              localStorage.setItem(result.achievements[i].name,
                  result.achievements[i].progress.toString());
            }
          } else {
            localStorage.setItem(result.achievements[i].name,
                result.achievements[i].progress.toString());
          }
        }
      },
    );
  }

  late File image;
}
