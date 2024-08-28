// ignore_for_file: library_private_types_in_public_api,
// unnecessary_to_list_in_spreads

import 'dart:convert';
import 'dart:math';

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
  late Future<List<Bird>> futureBirds;
  List<Bird> selectedBirds = [];
  late Bird correctBird;
  late Future<List<String>> birdImages;

  @override
  void initState() {
    super.initState();
    futureBirds = fetchBirds(http.Client());
  }

  void startQuiz(List<Bird> birds) {
    selectedBirds = selectRandomBirds(birds, 4);
    correctBird = selectedBirds[Random().nextInt(4)];
    birdImages = getImages(http.Client(), correctBird);
  }

  void showWinDialog(List<Bird> birds) {
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
                    setState(() {
                      startQuiz(birds);
                    });
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
                        'group': correctBird.commonGroup,
                        'species': correctBird.commonSpecies,
                        'id': correctBird.id.toString(),
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final padding = EdgeInsets.symmetric(
      horizontal: screenWidth * 0.05,
      vertical: screenHeight * 0.02,
    );

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
        child: FutureBuilder<List<Bird>>(
          future: futureBirds,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryColor(context)),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No birds found'));
            } else {
              startQuiz(snapshot.data!);
              return Column(
                children: [
                  Expanded(
                    child: FutureBuilder<List<String>>(
                      future: birdImages,
                      builder: (context, imageSnapshot) {
                        if (imageSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryColor(context)),
                            ),
                          );
                        } else if (imageSnapshot.hasError) {
                          return Center(
                              child: Text('Error: ${imageSnapshot.error}'));
                        } else if (imageSnapshot.data == null ||
                            imageSnapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No images available'));
                        } else {
                          return PageView(
                            children: imageSnapshot.data!
                                .map((url) => SizedBox(
                                      width: screenWidth * 0.9,
                                      child: Image.network(
                                        url,
                                        width: screenWidth * 0.9,
                                        fit: BoxFit.cover,
                                      ),
                                    ))
                                .toList(),
                          );
                        }
                      },
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
                    children: selectedBirds
                        .map((bird) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 6.0),
                              child: SizedBox(
                                width: min(screenWidth * 0.75, 320),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppColors.primaryColor(context),
                                    minimumSize: const Size(320, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    shadowColor: Colors.grey,
                                    elevation: 5,
                                  ),
                                  onPressed: () {
                                    if (bird == correctBird) {
                                      showWinDialog(snapshot.data!);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
              );
            }
          },
        ),
      ),
    );
  }
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
    throw Exception('Error fetching birdsYelllaosd: $error');
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
