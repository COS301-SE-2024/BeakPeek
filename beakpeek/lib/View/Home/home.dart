import 'package:beakpeek/Styles/home_page_styles.dart';
import 'package:flutter/material.dart';
import 'package:beakpeek/Styles/custom_buttons.dart';
import 'package:beakpeek/Model/top_search_bar.dart';
import 'package:beakpeek/Model/nav.dart';

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
                          const TopSearchBar(),
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
                              Image.asset(
                                'assets/images/home.png',
                                width:
                                    screenWidth * 0.92, // 92% of screen width
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  color: Colors.black.withOpacity(0.5),
                                  child: RichText(
                                    text: const TextSpan(
                                      text: 'Black Fronted Bushsrike',
                                      style: HomePageStyles.homeWhiteHeading,
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
                          SizedBox(height: screenHeight * 0.01),
                          Image.asset(
                            'assets/images/map.png',
                            width: screenWidth * 0.92,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          const Center(
                            child: CustomFilledButton(
                              routePath: '/map',
                              buttonText: 'View Map',
                              backgroundColor: Color(0xFF033A30),
                              textColor: Colors.white,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          const Center(
                            child: CustomFilledButton(
                              routePath: '/birdSearch',
                              buttonText: 'Search Birds Temp',
                              backgroundColor: Color(0xFF033A30),
                              textColor: Colors.white,
                            ),
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
        ));
  }
}
