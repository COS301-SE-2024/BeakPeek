import 'dart:convert';
import 'dart:math';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Model/Globals/globals.dart';
import 'package:beakpeek/Model/quiz_instance.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      for (String url in instance.images) {
        // ignore: use_build_context_synchronously
        precacheImage(NetworkImage(url), context);
      }
    }
  }

  Future<QuizInstance> createQuizInstance() async {
    final List<Bird> selectedBirds = selectRandomBirds(birds, 4);
    final Bird correctBird = selectedBirds[Random().nextInt(4)];
    final List<String> images = await getImages(http.Client(), correctBird);
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
  return birds.take(count).toList();
}

Future<List<String>> getImages(http.Client client, Bird bird) async {
  try {
    final String birdName = '${bird.commonSpecies} ${bird.commonGroup}';
    final response = await client.get(Uri.parse(
        'https://beakpeekbirdapi.azurewebsites.net/api/BirdInfo/$birdName'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> images = jsonResponse['images'];
      return images.map<String>((image) => image['url'] as String).toList();
    } else {
      throw Exception('Failed to load bird images');
    }
  } catch (error) {
    throw Exception('Error fetching bird images: $error');
  }
}
