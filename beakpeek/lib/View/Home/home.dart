// ignore_for_file: lines_longer_than_80_chars, unnecessary_brace_in_string_interps

import 'package:beakpeek/Model/BirdInfo/bird.dart';
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
  //final Globals globel = global;

  @override
  void initState() {
    //globel.init();
    super.initState();
    pentadId = getPentadId(); // Initialize pentadId
  }

  Future<List<Bird>> _fetchBirds() async {
    final id = await pentadId;
    return fetchBirds(id, http.Client()); // Fetch birds based on pentadId
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
                        SizedBox(height: screenHeight * 0.01),

                        // Quiz Section
                        Container(
                          width: sectionWidth,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: AppColors.popupColor(context),
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
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
                                          context.go('/quiz');
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
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

                        // Achievements Section
                        Container(
                          width: sectionWidth,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: AppColors.popupColor(context),
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
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
                                'Tracked Achievements',
                                style:
                                    GlobalStyles.smallHeadingPrimary(context),
                              ),
                              const SizedBox(height: 10),
                              // List of achievements
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  'Master Spotter',
                                  style: GlobalStyles.contentBold(context),
                                ),
                                subtitle: Text(
                                  '24% complete',
                                  style:
                                      GlobalStyles.smallContentPrimary(context),
                                ),
                                trailing: Icon(Icons.star,
                                    color: AppColors.tertiaryColor(context)),
                              ),
                              const Divider(color: Colors.grey),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  'Duck Specialist',
                                  style: GlobalStyles.contentBold(context),
                                ),
                                subtitle: Text(
                                  '56% complete',
                                  style:
                                      GlobalStyles.smallContentPrimary(context),
                                ),
                                trailing: Icon(Icons.star,
                                    color: AppColors.tertiaryColor(context)),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                            ],
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        // Birds Near You Section
                        FutureBuilder<List<Bird>>(
                          future: _fetchBirds(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text('No birds found.'));
                            } else {
                              final birdsList = snapshot.data!;
                              return Container(
                                width: sectionWidth,
                                height: screenHeight *
                                    0.4, // Fixed height for the container
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: AppColors.popupColor(context),
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
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
                                    const SizedBox(height: 16),
                                    Expanded(
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
                                                  const EdgeInsets.symmetric(),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
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
                                                  const SizedBox(height: 16),
                                                  Text(
                                                    'Scientific Name: ${bird.genus} ${bird.species}',
                                                    style: GlobalStyles
                                                        .smallContentPrimary(
                                                            context),
                                                  ),
                                                  Divider(
                                                      color:
                                                          AppColors.greyColor(
                                                              context)),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                        SizedBox(height: screenHeight * 0.02),
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
  final latDegrees = position.latitude.ceil();
  final lonDegrees = position.longitude.floor();

  final latDecimal = (position.latitude - latDegrees).abs();
  final lonDecimal = position.longitude - lonDegrees;

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
