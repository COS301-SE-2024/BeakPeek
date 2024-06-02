import 'package:flutter/material.dart';
import 'package:beakpeek/LandingText/cust_buttons.dart';
import 'package:beakpeek/LandingText/cust_rich_text.dart';
import 'package:beakpeek/LandingText/nav.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: Home(),
//       ),
//     );
//   }
// }

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Color(0xFFF3F1ED),
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
                          const CustRichText(
                            'Bird of the Day',
                            Color(0xFF033A30),
                            ta: TextAlign.left,
                            fontS: 22,
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
                                  child: const CustRichText(
                                    'Black Fronted Bushsrike',
                                    Colors.white,
                                    fontS: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          const CustRichText(
                            'Your Area Map',
                            Color(0xFF033A30),
                            ta: TextAlign.left,
                            fontS: 22,
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Image.asset(
                            'assets/images/map.png',
                            width: screenWidth * 0.92,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          const Center(
                            child: CustButtons(
                              '/map',
                              'View Map',
                              Color(0xFF033A30),
                              Colors.white,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          const Center(
                            child: CustButtons(
                              '/birdSearch',
                              'Search Birds Temp',
                              Color(0xFF033A30),
                              Colors.white,
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

class TopSearchBar extends StatelessWidget {
  const TopSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Image.asset(
          'assets/icons/Logo.png',
          width: screenWidth * 0.1, // 10% of screen width
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEB),
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3F737373),
                blurRadius: 20,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Search birds and sightings...',
                style: TextStyle(
                  color: Color(0x9900383E),
                  fontSize: 16,
                  fontFamily: 'SF Pro Display',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Opacity(
                opacity: 0.60,
                child: Image.asset(
                  'assets/icons/search.png',
                  width: screenWidth * 0.05, // 5% of screen width
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
