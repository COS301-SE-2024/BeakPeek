import 'package:beakpeek/Model/BirdInfo/bird.dart';

class QuizInstance {
  QuizInstance({
    required this.selectedBirds,
    required this.correctBird,
    required this.images,
  });
  final List<Bird> selectedBirds;
  final Bird correctBird;
  final List<String> images;
}
