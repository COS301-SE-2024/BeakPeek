library global;

import 'dart:io';

import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:beakpeek/Controller/Home/search.dart';
import 'package:beakpeek/Controller/Main/color_palette_functions.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Model/UserProfile/achievment_list.dart';
import 'package:beakpeek/View/Home/home.dart';
import 'package:beakpeek/View/Map/bird_sheet.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;

Globals global = Globals();

class Globals {
  final LifeListProvider lifeList = LifeListProvider.instance;
  late List<Bird> birdList = [];
  late List<Bird> allBirdsList = [];
  late Future<String> cachedPentadId;
  List<Bird>? cachedBirds;
  ColorPalette palette = greenRedPalette;

  void init() async {
    // Fetch cached Pentad ID and birds if available

    cachedPentadId = getPentadId();

    // Fetch birds using the cached or newly fetched Pentad ID
    cachedPentadId.then((pentadId) {
      fetchBirds(pentadId, http.Client());
    });

    // Load bird data from assets and insert into lifeList
    listBirdFromAssets().then((result) {
      allBirdsList = result;
      lifeList.initialInsert(result);
      lifeList.initialProvInsert(result);
    });
  }

  Future<List<Bird>> updateLife() async {
    return birdList = await lifeList.fetchLifeList();
  }

  Bird getDefualtBirdData(int id) {
    return allBirdsList.firstWhere((bird) => bird.id == id);
  }

  void getAchievments() {
    getAchivementList().then((result) {
      for (int i = 0; i < result.achievements.length; i++) {
        if (localStorage.getItem(result.achievements[i].name) != null) {
          final double localProgress =
              double.parse(localStorage.getItem(result.achievements[i].name)!);

          if (result.achievements[i].progress > localProgress) {
            localStorage.setItem(result.achievements[i].name,
                result.achievements[i].progress.toString());
          }
        } else {
          localStorage.setItem(result.achievements[i].name,
              result.achievements[i].progress.toString());
        }
      }
    });
  }

  Future<String> getPentadId() async {
    final Position position = await Geolocator.getCurrentPosition();
    final latitude = position.latitude;
    final longitude = position.longitude;

    // Check if the location is within South Africa's boundaries
    if (latitude < -35.0 ||
        latitude > -22.0 ||
        longitude < 16.0 ||
        longitude > 33.0) {
      throw Exception('Location is outside South Africa.');
    }

    final latDegrees = latitude.ceil();
    final lonDegrees = longitude.floor();

    final latDecimal = (latitude - latDegrees).abs();
    final lonDecimal = longitude - lonDegrees;

    // Convert decimal part to minutes
    final latMinutes = ((latDecimal * 60) - (latDecimal * 60) % 5).toInt();
    final lonMinutes = ((lonDecimal * 60) - (lonDecimal * 60) % 5).toInt();

    // Format the result
    final formattedLat =
        '${latDegrees.abs()}${latMinutes.toString().padLeft(2, "0")}';
    final formattedLon =
        '${lonDegrees.abs()}${lonMinutes.toString().padLeft(2, "0")}';

    // Combine with underscore
    return '${formattedLat}_${formattedLon}';
  }
}
