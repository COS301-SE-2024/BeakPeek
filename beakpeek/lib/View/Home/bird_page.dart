import 'package:beakpeek/Styles/global_styles.dart';
import 'package:flutter/material.dart';
import 'package:beakpeek/Styles/bird_page_styles.dart';
import 'package:beakpeek/Model/nav.dart';

class BirdPage extends StatelessWidget {
  const BirdPage({super.key});

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
                      children: [
                        SizedBox(height: screenHeight * 0.05),
                        const Row(
                          children: [
                            SizedBox(width: 16.0),
                            Text(
                              'Black Fronted Bushshrike',
                              style: TextStyle(
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
                              child: Image.asset(
                                'assets/images/home.png',
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
                                // ignore: lines_longer_than_80_chars
                                'A striking bird with black and yellow plumage. This bird is known for its vibrant colors and melodic song. It can often be seen in forest edges, woodlands, and gardens, and has a diet that mainly consists of insects and small invertebrates.',
                                style:
                                    GlobalStyles.content.copyWith(fontSize: 18),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Action for the button
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
