import 'package:beakpeek/View/Home/bird_quiz.dart';
import 'package:flutter/material.dart';
// Adjust the import to the correct file path

void main() {
  runApp(BirdQuizApp());
}

class BirdQuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bird Quiz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BirdQuiz(),
    );
  }
}
