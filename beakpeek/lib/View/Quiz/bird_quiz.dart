// ignore_for_file: library_private_types_in_public_api,
// unnecessary_to_list_in_spreads

import 'dart:convert';
import 'dart:math';

import 'package:beakpeek/Model/BirdInfo/bird.dart';
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
          title: const Text('Congratulations!'),
          content: const Text('You selected the correct bird!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                setState(() {
                  startQuiz(birds);
                });
              },
              child: const Text('Play Again'),
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
              child: const Text('Go to Bird Page'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bird Quiz')),
      body: FutureBuilder<List<Bird>>(
        future: futureBirds,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No birds found'));
          } else {
            startQuiz(snapshot.data!);
            return Column(
              children: [
                FutureBuilder<List<String>>(
                  future: birdImages,
                  builder: (context, imageSnapshot) {
                    if (imageSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (imageSnapshot.hasError) {
                      return Center(
                          child: Text('Error: ${imageSnapshot.error}'));
                    } else {
                      return Expanded(
                        child: PageView(
                          children: imageSnapshot.data!
                              .map((url) => Image.network(url))
                              .toList(),
                        ),
                      );
                    }
                  },
                ),
                ...selectedBirds
                    .map((bird) => ElevatedButton(
                          onPressed: () {
                            if (bird.commonSpecies ==
                                    correctBird.commonSpecies &&
                                bird.commonGroup == correctBird.commonGroup) {
                              showWinDialog(
                                  snapshot.data!); // Show popup dialog
                            } else {
                              // Incorrect answer
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Incorrect!'),
                                backgroundColor: Colors.red,
                              ));
                            }
                          },
                          child:
                              Text('${bird.commonSpecies} ${bird.commonGroup}'),
                        ))
                    // ignore: unnecessary_to_list_in_spreads
                    .toList(),
              ],
            );
          }
        },
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
