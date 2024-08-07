// ignore_for_file: library_private_types_in_public_api

import 'package:beakpeek/Model/bird_page_functions.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:beakpeek/Styles/bird_page_styles.dart';
import 'package:beakpeek/Model/nav.dart';
import 'package:beakpeek/View/Home/heat_map.dart';
import 'package:flutter/material.dart';

class BirdPage extends StatefulWidget {
  // ignore: lines_longer_than_80_chars
  const BirdPage(
      {super.key,
      required this.commonGroup,
      required this.commonSpecies,
      required this.id});

  final String commonGroup;
  final String commonSpecies;
  final int id;

  @override
  _BirdPageState createState() => _BirdPageState();
}

class _BirdPageState extends State<BirdPage> {
  late Future<Map<String, dynamic>?> birdFuture;

  @override
  void initState() {
    super.initState();
    birdFuture =
        ApiService().fetchBirdInfo(widget.commonGroup, widget.commonSpecies);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F1ED),
      body: Center(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: FutureBuilder<Map<String, dynamic>?>(
                      future: birdFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text('Failed to load bird info'));
                        } else if (!snapshot.hasData) {
                          return const Center(
                              child: Text('No bird info found'));
                        }

                        final birdData = snapshot.data!;
                        return Column(
                          children: [
                            SizedBox(height: screenHeight * 0.05),
                            Row(
                              children: [
                                const SizedBox(width: 16.0),
                                Text(
                                  birdData['name'],
                                  style: const TextStyle(
                                    color: GlobalStyles.primaryColor,
                                    fontSize: 22,
                                    fontFamily: 'SF Pro Display',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Center(
                              child: Container(
                                width: screenWidth * 0.92,
                                height: screenWidth * 0.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 3,
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    birdData['images'][1][
                                        'url'], // Assuming you have an imageUrl
                                    //in your data
                                    width: screenWidth * 0.92,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.description,
                                        color: BirdPageStyles.primaryColor,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Description',
                                        style: GlobalStyles.smallHeadingDark,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    birdData['description'],
                                    // Assuming you have a
                                    //description in your data
                                    style: GlobalStyles.content
                                        .copyWith(fontSize: 18),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        body: HeatMap(
                          id: widget.id,
                        ),
                      ),
                    ),
                  );
                },
                style: BirdPageStyles.elevatedButtonStyle(),
                child: const Text('Show Heat Map'),
              ),
              const BottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }
}
