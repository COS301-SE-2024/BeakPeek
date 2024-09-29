library global;

import 'dart:io';

import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:beakpeek/Controller/Home/search.dart';
import 'package:beakpeek/Controller/Main/color_palette_functions.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';

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
      lifeList.initialInsert(result);
      lifeList.initialProvInsert(result);
    });
    lifeList.getFullBirdData().then((data) {
      allBirdsList = data;
    });
    //lifeList.deleteDatabaseFile();
  }

  Future<List<Bird>> updateLife() async {
    return birdList = await lifeList.fetchLifeList();
  }

  Bird getDefualtBirdData(int id) {
    return allBirdsList.firstWhere((bird) => bird.id == id);
  }

  late File image;
}
