import 'package:beakpeek/Model/top_search_bar.dart';
import 'package:beakpeek/View/Home/bird_map.dart';
import 'package:flutter/material.dart';
import 'package:beakpeek/Model/nav.dart';
import 'package:beakpeek/Styles/map_page_styles.dart';
import 'package:beakpeek/Model/help_icon_model_functions.dart';

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: Scaffold(
//         backgroundColor: Color(0xFFF3F1ED),
//         body: MapInfo(),
//       ),
//     );
//   }
// }

class MapInfo extends StatelessWidget {
  const MapInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F1ED),
      body: Center(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                // child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      const TopSearchBar(),
                      const SizedBox(height: 20),
                      RichText(
                        text: const TextSpan(
                          text: 'Your Area Map',
                          style: MapPageStyles.mapHeadingGreen,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(width: 8), // Spacing between text
                      GestureDetector(
                        onTap: () {
                          const content =
                              '''This map shows you your current location. 
                              Click anywhere and you will see all the birds in that area! 
                              You can use the filters to customise what you see. 
                              You can use the search bar to see the heat map of a specific bird!''';
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
                      const SizedBox(height: 10),
                      const Expanded(
                        child: BirdMap(),
                      )
                    ],
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
