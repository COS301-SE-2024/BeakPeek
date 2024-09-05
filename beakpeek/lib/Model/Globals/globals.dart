library global;

import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:beakpeek/Controller/Home/search.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';

Globals global = Globals();

class Globals {
  final LifeListProvider lifeList = LifeListProvider.instance;
  late List<Bird> birdList = [];
  late List<Bird> allBirdsList = [];

  void init() {
    lifeList.fetchLifeList().then((result) {
      birdList = result;
    });
    listBirdFromAssets().then((result) {
      allBirdsList = result;
    });
  }

  void updateLife() {
    lifeList.fetchLifeList().then((result) {
      birdList = result;
    });
  }
}

//apk downloadable link
