// ignore_for_file: lines_longer_than_80_chars, unnecessary_brace_in_string_interps, empty_catches

import 'package:beakpeek/Controller/Home/quiz_manager.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Model/Globals/globals.dart';
import 'package:beakpeek/Styles/colors.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:beakpeek/View/Bird/bird_page.dart';
import 'package:beakpeek/View/Home/Searching/filterable_searchbar.dart';
import 'package:beakpeek/View/Map/bird_sheet.dart';
import 'package:flutter/material.dart';
import 'package:beakpeek/Model/nav.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  late Future<String> pentadId;
  final QuizManager _quizManager = QuizManager();

  @override
  void initState() {
    //globel.init();
    super.initState();
    pentadId = _getPentadIdWithCache(); // Initialize pentadId
    preloadQuizzes();
  }

  Future<void> preloadQuizzes() async {
    try {
      await _quizManager.preloadQuizzes(3, context);
    } catch (e) {}
  }

  Future<List<Bird>> _fetchBirdsWithCache() async {
    if (global.cachedBirds != null) {
      // Return cached birds if available
      return global.cachedBirds!;
    }

    final id = await pentadId;
    global.cachedBirds = await fetchBirds(id, http.Client());
    return global.cachedBirds!;
  }

  Future<String> _getPentadIdWithCache() async {
    if (global.cachedPentadId != null) {
      // Return cached pentadId if available
      return global.cachedPentadId!;
    }

    global.cachedPentadId = await getPentadId(); // Cache pentadId
    return global.cachedPentadId!;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final sectionWidth = screenWidth * 0.92;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor(context),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.05),
                        const FilterableSearchbar(
                          helpContent: 'Help for home page',
                        ),
                        SizedBox(height: screenHeight * 0.03),

                        // Quiz Section
                        Container(
                          width: sectionWidth,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: AppColors.popupColor(context),
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Test Your Knowledge!',
                                style:
                                    GlobalStyles.smallHeadingPrimary(context),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Guess the bird from the picture...',
                                style: GlobalStyles.contentSecondary(context),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                height: screenHeight * 0.25,
                                decoration: BoxDecoration(
                                  color: AppColors.popupColor(context),
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                        'assets/images/quiz_placeholder.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: 8.0,
                                      right: 16.0,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          context.goNamed('quiz');
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            elevation: 10,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 8.0),
                                            backgroundColor:
                                                AppColors.popupColor(context)),
                                        child: Text(
                                          'Start Quiz',
                                          style: GlobalStyles.contentSecondary(
                                              context),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        // Birds Near You Section
                        FutureBuilder<List<Bird>>(
                          future: _fetchBirdsWithCache(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 15),
                                    CircularProgressIndicator(
                                      color: AppColors.primaryColor(context),
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      'Loading birds near you...',
                                      style:
                                          GlobalStyles.contentPrimary(context),
                                    ),
                                  ],
                                ),
                              );
                            } else if (snapshot.hasError) {
                              if (snapshot.error.toString().contains(
                                  'Location is outside South Africa')) {
                                return Center(
                                  child: Column(
                                    children: [
                                      const Icon(Icons.error_outline,
                                          size: 50, color: Colors.red),
                                      const SizedBox(height: 15),
                                      Text(
                                        'You need to be in South Africa to view birds in this area.',
                                        style: GlobalStyles.contentPrimary(
                                            context),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Please enable location or move to a region within South Africa.',
                                        style: GlobalStyles.smallContentPrimary(
                                            context),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              }
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Center(
                                child: Column(
                                  children: [
                                    Icon(Icons.error_outline,
                                        size: 50, color: Colors.red),
                                    const SizedBox(height: 15),
                                    Text(
                                      'Unable to Load Birds near you!',
                                      style:
                                          GlobalStyles.contentPrimary(context),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Please try again soon.',
                                      style: GlobalStyles.smallContentPrimary(
                                          context),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              final birdsList = snapshot.data!;
                              return Container(
                                width: sectionWidth,
                                height: screenHeight * 0.37,
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: AppColors.popupColor(context),
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Birds Near You',
                                      style: GlobalStyles.smallHeadingPrimary(
                                          context),
                                    ),
                                    Expanded(
                                      child: Scrollbar(
                                        child: ListView.builder(
                                          itemCount: birdsList.length,
                                          itemBuilder: (context, index) {
                                            final bird = birdsList[index];
                                            return InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Scaffold(
                                                      body: BirdPage(
                                                        id: bird.id,
                                                        commonGroup:
                                                            bird.commonGroup,
                                                        commonSpecies:
                                                            bird.commonSpecies,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0),
                                                child: Row(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
                                                              bird.imageUrl ??
                                                                  ''),
                                                      radius: 25,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                bird.commonGroup !=
                                                                        'None'
                                                                    ? '${bird.commonSpecies} ${bird.commonGroup}'
                                                                    : bird
                                                                        .commonSpecies,
                                                                style: GlobalStyles
                                                                    .contentBold(
                                                                        context),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 16),
                                                          Text(
                                                            'Scientific Name: ${bird.genus} ${bird.species}',
                                                            style: GlobalStyles
                                                                .smallContentPrimary(
                                                                    context),
                                                          ),
                                                          Divider(
                                                              color: AppColors
                                                                  .greyColor(
                                                                      context)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const BottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String> getPentadId() async {
  final Position position = await Geolocator.getCurrentPosition();
  final latitude = position.latitude;
  final longitude = position.longitude;

  // Check if the location is within South Africa's boundaries
  if (latitude < -35.0 ||
      latitude > -22.0 ||
      longitude < 16.0 ||
      longitude > 33.0) {
    throw Exception('Location is outside South Africa.');
  }

  final latDegrees = latitude.ceil();
  final lonDegrees = longitude.floor();

  final latDecimal = (latitude - latDegrees).abs();
  final lonDecimal = longitude - lonDegrees;

  // Convert decimal part to minutes
  final latMinutes = ((latDecimal * 60) - (latDecimal * 60) % 5).toInt();
  final lonMinutes = ((lonDecimal * 60) - (lonDecimal * 60) % 5).toInt();

  // Format the result
  final formattedLat =
      '${latDegrees.abs()}${latMinutes.toString().padLeft(2, "0")}';
  final formattedLon =
      '${lonDegrees.abs()}${lonMinutes.toString().padLeft(2, "0")}';
  // Combine with underscore
  return '${formattedLat}_${formattedLon}';
}
