import 'package:beakpeek/Styles/global_styles.dart';
import 'package:flutter/material.dart';
import 'package:beakpeek/Model/nav.dart';
import 'package:beakpeek/View/Home/Searching/searchbar_container.dart';
import 'package:beakpeek/Styles/home_page_styles.dart';
import 'package:beakpeek/Model/help_icon_model_functions.dart';
import 'package:go_router/go_router.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Define text style for chip labels
    final chipTextStyle = TextStyle(
      color: Colors.grey[700], // Match the color used in achievements
      fontSize: 16,
    );

    // Define a constant width for the sections
    final sectionWidth = screenWidth * 0.92; // 92% of screen width

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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.05),
                        const SearchbarContainer(),
                        SizedBox(height: screenHeight * 0.01),

                        // Quiz Section
                        Container(
                          width: sectionWidth,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Test Your Knowledge!',
                                style: GlobalStyles.smallHeadingDark,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Guess the bird from the picture...',
                                style: GlobalStyles.greyContent,
                              ),
                              const SizedBox(height: 10),
                              Container(
                                height: screenHeight * 0.25,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                        'assets/images/quiz_placeholder.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Start Quiz',
                                    style: GlobalStyles.smallContent,
                                  ),
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
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tracked Achievements',
                                style: GlobalStyles.smallHeadingDark,
                              ),
                              SizedBox(height: 10),
                              ListTile(
                                title: Text('Achievement 1',
                                    style: GlobalStyles.boldContent),
                                subtitle: Text('75% complete',
                                    style: GlobalStyles.greyContent),
                                trailing: Icon(Icons.star, color: Colors.amber),
                              ),
                              ListTile(
                                title: Text('Achievement 2',
                                    style: GlobalStyles.boldContent),
                                subtitle: Text('50% complete',
                                    style: GlobalStyles.greyContent),
                                trailing: Icon(Icons.star, color: Colors.amber),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // Bird Wishlist Section
                        Container(
                          width: sectionWidth,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Birds You Want to See',
                                style: GlobalStyles.smallHeadingDark,
                              ),
                              SizedBox(height: 10),

                              // Use Column for vertical layout
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Chip(
                                    label: Text('Brown-Headed Parrot',
                                        style: GlobalStyles.greyContent),
                                  ),
                                  Chip(
                                    label: Text('Cape Vulture',
                                        style: GlobalStyles.greyContent),
                                  ),
                                  Chip(
                                    label: const Text('Honeyguide',
                                        style: GlobalStyles.greyContent),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
