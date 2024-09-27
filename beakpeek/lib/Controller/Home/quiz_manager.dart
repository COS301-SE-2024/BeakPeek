// ignore_for_file: non_constant_identifier_names, duplicate_ignore, use_build_context_synchronously, lines_longer_than_80_chars, avoid_print
import 'dart:math';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Model/Globals/globals.dart';
import 'package:beakpeek/Model/quiz_instance.dart';
import 'package:flutter/material.dart';

class QuizManager {
  factory QuizManager() {
    return _instance;
  }
  QuizManager._internal();
  static final QuizManager _instance = QuizManager._internal();
  late List<Bird> birds = global.allBirdsList;

  final List<QuizInstance> _preloadedQuizzes = [];

  List<QuizInstance> get preloadedQuizzes => _preloadedQuizzes;

  Future<void> preloadQuizzes(int count, BuildContext context) async {
    for (int i = 0; i < count; i++) {
      final QuizInstance instance = await createQuizInstance();
      _preloadedQuizzes.add(instance);
      precacheImage(NetworkImage(instance.images), context);
    }
  }

  Future<QuizInstance> createQuizInstance() async {
    final List<Bird> selectedBirds = selectRandomBirds(birds, 4);
    final Bird correctBird = selectedBirds[Random().nextInt(4)];
    final String images = correctBird.imageUrl ?? '';
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

List<Bird> selectRandomBirds(List<Bird> birds, int count) {
  birds.shuffle(Random());
  List<Bird> selectedBirds = [];

  while (selectedBirds.length < count) {
    Bird randomBird = birds[Random().nextInt(birds.length)];

    // Check if the bird has a valid imageUrl
    if (randomBird.imageUrl != null && randomBird.imageUrl!.isNotEmpty) {
      selectedBirds.add(randomBird);
    }
  }

  return selectedBirds;
}
