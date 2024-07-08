import 'package:beakpeek/Styles/home_page_styles.dart';
import 'package:beakpeek/View/Home/Searching/searchbar_container.dart';
import 'package:flutter/material.dart';
import 'package:beakpeek/Model/nav.dart';
import 'package:beakpeek/Model/help_icon_model_functions.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.05),
                        const SearchbarContainer(),
                        SizedBox(height: screenHeight * 0.01),
                        RichText(
                          text: const TextSpan(
                            text: 'Bird of the Day',
                            style: HomePageStyles.homeGreenHeading,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    20.0), // Adjust radius as needed
                                child: Image.asset(
                                  'assets/images/home.png',
                                  width:
                                      screenWidth * 0.92, // 92% of screen width
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: RichText(
                                    text: const TextSpan(
                                      text: 'Black Fronted Bushshrike',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'SF Pro Display',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        RichText(
                          text: const TextSpan(
                            text: 'Your Area Map',
                            style: HomePageStyles.homeGreenHeading,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(width: 8), // Spacing between text
                        GestureDetector(
                          key: const Key('helpLogo'),
                          onTap: () {
                            const content =
                                // ignore: lines_longer_than_80_chars
                                'This map shows you your current location. Click anywhere and you will see all the birds in that area! You can use the filters to customise what you see and you can use the search bar to see the heat map of a specific bird!';
                            showHelpPopup(context, content);
                          },
                          child: const Icon(
                            IconData(0xe309,
                                fontFamily: 'MaterialIcons',
                                matchTextDirection: true),
                            size: 20.0, // Adjust size as needed
                            color: Colors
                                .green, // Optional: Set color to match theme
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Image.asset(
                          'assets/images/map.png',
                          width: screenWidth * 0.92,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: screenHeight * 0.01),

                        SizedBox(height: screenHeight * 0.01),
                        Center(
                          child: FilledButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/map');
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF033A30),
                              minimumSize: const Size(350, 50),
                              shadowColor: Colors.black,
                            ),
                            child: const Text(
                              'View Map',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontFamily: 'SF Pro Display',
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
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
