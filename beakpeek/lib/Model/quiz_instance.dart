import 'package:beakpeek/Model/BirdInfo/bird.dart';

class QuizInstance {
  final List<Bird> selectedBirds;
  final Bird correctBird;
  final List<String> images;

  QuizInstance({
    required this.selectedBirds,
    required this.correctBird,
    required this.images,
  });
}
