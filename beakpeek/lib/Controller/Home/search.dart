import 'dart:convert';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:flutter/services.dart';

Future<List<dynamic>> loadJsonFromAssets() async {
  final String jsonString =
      await rootBundle.loadString('assets/BirdList/allbirds.json');
  return jsonDecode(jsonString);
}

Future<List<Bird>> listBirdFromAssets() {
  late final Future<List<Bird>> result = loadJsonFromAssets().then(
    (value) {
      return value.map((data) => Bird.fromJson(data)).toList();
    },
  );
  return result;
}
