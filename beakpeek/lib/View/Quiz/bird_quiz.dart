// ignore_for_file: library_private_types_in_public_api,, empty_catches
// unnecessary_to_list_in_spreads
import 'dart:math';
import 'package:beakpeek/Controller/Home/quiz_manager.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Model/UserProfile/user_model.dart';
import 'package:beakpeek/Model/quiz_instance.dart';
import 'package:beakpeek/Styles/colors.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:beakpeek/View/Bird/bird_page.dart';
import 'package:beakpeek/config_azure.dart';
import 'package:flutter/material.dart';

class BirdQuiz extends StatefulWidget {
  const BirdQuiz({super.key});

  @override
  _BirdQuizState createState() => _BirdQuizState();
}

class _BirdQuizState extends State<BirdQuiz>
    with SingleTickerProviderStateMixin {
  final QuizManager _quizManager = QuizManager();
  QuizInstance? currentQuiz;
  Bird? selectedBird;
  bool isAnswered = false;
  int correctAnswersInRow = 0;
  int highScore = 0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10), // 10-second timer for each bird
    );

    // Call setState on each tick to rebuild and update the timer bar
    _controller.addListener(() {
      setState(() {});
      if (_controller.isCompleted && !isAnswered) {
        // Time runs out and the player hasn't answered
        showGameOverPopup();
      }
    });

    loadNextQuiz();
  }

  void loadNextQuiz() {
    setState(() {
      currentQuiz = _quizManager.getNextQuizInstance();
      selectedBird = null;
      isAnswered = false;
      _controller.reset(); // Reset the timer
      _controller.forward(); // Start the timer
      try {
        _quizManager.preloadQuizzes(1, context);
        // ignore: empty_catches
      } catch (e) {}
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void handleAnswer(Bird bird) async {
    if (isAnswered) {
      return; // Ignore input if already answered
    }
    setState(() {
      isAnswered = true;
      selectedBird = bird; // Highlight the selected bird
    });

    if (bird == currentQuiz!.correctBird) {
      setState(() {
        correctAnswersInRow++;
      });
      await Future.delayed(const Duration(seconds: 1));
      loadNextQuiz();
    } else {
      // Highlight the correct answer
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        // Set the selected wrong answer to red
        selectedBird = bird;
        // Update the correct bird to green
      });
      user.highscore = max(user.highscore, correctAnswersInRow);
      storeUserLocally(user);
      updateOnline();
      showGameOverPopup();
    }
  }

  void showGameOverPopup() {
    _controller.stop();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundColor(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          contentPadding: const EdgeInsets.all(0), // Remove default padding
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add a back button at the top left
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: AppColors.iconColor(context)),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      Navigator.of(context).pop(); // Exit the quiz
                    },
                  ), // Spacer to align content
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.sentiment_dissatisfied,
                      size: 64,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Game Over!',
                      style: GlobalStyles.smallHeadingPrimary(context).copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GlobalStyles.contentPrimary(context),
                        children: [
                          const TextSpan(text: 'Correct answers in a row: '),
                          TextSpan(
                            text: '$correctAnswersInRow',
                            style:
                                GlobalStyles.contentTertiary(context).copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GlobalStyles.contentPrimary(context),
                        children: [
                          const TextSpan(text: 'High score: '),
                          TextSpan(
                            text: '${user.highscore}',
                            style:
                                GlobalStyles.contentTertiary(context).copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              correctAnswersInRow = 0;
                            });
                            Navigator.of(context).pop();
                            loadNextQuiz();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 24.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor: AppColors.popupColorDark,
                          ),
                          icon: Icon(Icons.refresh,
                              color: AppColors.iconColorDark),
                          label: Text(
                            'Try Again',
                            style: GlobalStyles.smallContent(context).copyWith(
                              color: AppColors.primaryButtonTextColor(context),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Scaffold(
                                  body: BirdPage(
                                    id: currentQuiz!.correctBird.id,
                                  ),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 24.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor: AppColors.tertiaryColor(context),
                          ),
                          icon: Icon(Icons.visibility,
                              color: AppColors.iconColor(context)),
                          label: Text(
                            'View Bird',
                            style: GlobalStyles.smallContent(context).copyWith(
                              color: AppColors.textColor(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (currentQuiz == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor(context),
        elevation: 0,
        title: Text(
          'Bird Quiz',
          style: GlobalStyles.smallHeadingPrimary(context),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Timer Bar
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 8, // Set the height of the timer bar
                  child: LinearProgressIndicator(
                    value: 1.0 -
                        _controller.value, // Inverted so it shrinks over time
                    backgroundColor: Colors.grey[300],
                    color: AppColors.tertiaryColor(context), // Customize color
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Score Tracker
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current Score: $correctAnswersInRow',
                  style: GlobalStyles.contentPrimary(context),
                ),
                Text(
                  'High Score: ${user.highscore}',
                  style: GlobalStyles.contentPrimary(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0), // Add border radius
              child: Image.network(
                currentQuiz?.images ?? '', // The image URL
                fit: BoxFit.cover, // Adjust image to cover the container
                width: screenWidth * 0.9,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Select the correct bird:',
            style: GlobalStyles.smallHeadingPrimary(context),
          ),
          const SizedBox(height: 16),
          Column(
            children: currentQuiz!.selectedBirds.map((bird) {
              final isCorrectBird = bird == currentQuiz!.correctBird;
              final isSelectedBird = bird == selectedBird;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: SizedBox(
                  width: min(screenWidth * 0.75, 320),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelectedBird
                          ? (isCorrectBird
                              ? const Color.fromARGB(255, 105, 189, 108)
                              : const Color.fromARGB(255, 219, 89,
                                  79)) // Red for wrong, green for correct
                          : (isCorrectBird && isAnswered)
                              ? const Color.fromARGB(255, 105, 189, 108)
                              : AppColors.popupColor(context),
                      // Green if it’s correct and answered
                      minimumSize: const Size(320, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: () => handleAnswer(bird),
                    child: Text(
                      '${bird.commonSpecies} ${bird.commonGroup}',
                      style: GlobalStyles.contentPrimary(context),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
