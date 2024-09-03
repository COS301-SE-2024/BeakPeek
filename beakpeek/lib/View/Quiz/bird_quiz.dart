// ignore_for_file: library_private_types_in_public_api,
// unnecessary_to_list_in_spreads

import 'dart:convert';
import 'dart:math';

import 'package:beakpeek/Controller/Home/quiz_manager.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Styles/colors.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class BirdQuiz extends StatefulWidget {
  const BirdQuiz({super.key});

  @override
  _BirdQuizState createState() => _BirdQuizState();
}

class _BirdQuizState extends State<BirdQuiz> {
  final QuizManager _quizManager = QuizManager();
  QuizInstance? currentQuiz;

  @override
  void initState() {
    super.initState();
    // _quizManager.preloadQuizzes(1, context);
    loadNextQuiz();
  }

  void loadNextQuiz() {
    setState(() {
      currentQuiz = _quizManager.getNextQuizInstance();
      if (_quizManager.getNextQuizInstance() == null) {
        try {
          _quizManager.preloadQuizzes(1, context);
        } catch (e) {}
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final padding = EdgeInsets.symmetric(
      horizontal: screenWidth * 0.05,
      vertical: screenHeight * 0.02,
    );

    if (currentQuiz == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F1ED),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F1ED),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.iconColor(context),
          ),
          onPressed: () => context.go('/home'),
        ),
        title: Text(
          'Bird Quiz',
          style: GlobalStyles.smallHeadingPrimary(context),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: padding,
        child: Column(
          children: [
            Expanded(
              child: PageView(
                children: currentQuiz!.images
                    .map((url) => SizedBox(
                          width: screenWidth * 0.9,
                          child: Image.network(
                            url,
                            width: screenWidth * 0.9,
                            fit: BoxFit.cover,
                          ),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Select the correct bird:',
              style: GlobalStyles.smallHeadingPrimary(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Column(
              children: currentQuiz!.selectedBirds
                  .map((bird) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: SizedBox(
                          width: min(screenWidth * 0.75, 320),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor(context),
                              minimumSize: const Size(320, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              shadowColor: Colors.grey,
                              elevation: 5,
                            ),
                            onPressed: () {
                              if (bird == currentQuiz!.correctBird) {
                                showWinDialog();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Try again!'),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              '${bird.commonSpecies} ${bird.commonGroup}',
                              style: const TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontFamily: 'SF Pro Display',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  void showWinDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              'Congratulations!',
              style: GlobalStyles.smallHeadingPrimary(context),
            ),
          ),
          content: Text(
            'You selected the correct bird!',
            style: GlobalStyles.contentPrimary(context),
          ),
          actions: [
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    loadNextQuiz();
                  },
                  child: Text(
                    'Next Bird',
                    style: GlobalStyles.contentPrimary(context),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.pop();
                    context.goNamed(
                      'birdInfo',
                      pathParameters: {
                        'group': currentQuiz!.correctBird.commonGroup,
                        'species': currentQuiz!.correctBird.commonSpecies,
                        'id': currentQuiz!.correctBird.id.toString(),
                      },
                    );
                  },
                  child: Text(
                    'View Bird',
                    style: GlobalStyles.contentPrimary(context),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

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

Future<List<Bird>> fetchBirds(http.Client client) async {
  try {
    final response = await client
        .get(Uri.parse('https://beakpeekbirdapi.azurewebsites.net/api/Bird/'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Bird.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load birds');
    }
  } catch (error) {
    throw Exception('Error fetching birds: $error');
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
