import 'dart:math';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Model/Globals/globals.dart';
import 'package:beakpeek/View/Quiz/bird_quiz.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuizManager {
  QuizManager._internal();
  static final QuizManager _instance = QuizManager._internal();

  factory QuizManager() {
    return _instance;
  }
  final Globals Global = global;
  late List<Bird> Birds = Global.allBirdsList;

  List<QuizInstance> _preloadedQuizzes = [];

  List<QuizInstance> get preloadedQuizzes => _preloadedQuizzes;

  Future<void> preloadQuizzes(int count, BuildContext context) async {
    for (int i = 0; i < count; i++) {
      QuizInstance instance = await createQuizInstance();
      _preloadedQuizzes.add(instance);
      for (String url in instance.images) {
        precacheImage(NetworkImage(url), context);
      }
    }
  }

  Future<QuizInstance> createQuizInstance() async {
    List<Bird> selectedBirds = selectRandomBirds(Birds, 4);
    Bird correctBird = selectedBirds[Random().nextInt(4)];
    List<String> images = await getImages(http.Client(), correctBird);
    return QuizInstance(
      selectedBirds: selectedBirds,
      correctBird: correctBird,
      images: images,
    );
  }

  QuizInstance? getNextQuizInstance() {
    return _preloadedQuizzes.isNotEmpty ? _preloadedQuizzes.removeAt(0) : null;
  }
}
