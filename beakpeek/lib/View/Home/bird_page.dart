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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.05),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              color: BirdPageStyles.primaryColor,
                              onPressed: () {
                                Navigator.pushNamed(context, '/home');
                              },
                            ),
                            const Text(
                              'Bird Information',
                              style: BirdPageStyles.heading,
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.asset(
                              'assets/images/home.png',
                              width: screenWidth * 0.92,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // Bird name
                        const ProfileField(
                          icon: Icons.info,
                          label: 'Name',
                          content: 'Black Fronted Bushshrike',
                          prominent: true,
                        ),
                        SizedBox(height: screenHeight * 0.01),

                        // Bird description
                        const ProfileField(
                          icon: Icons.description,
                          label: 'Description',
                          content:
                              // ignore: lines_longer_than_80_chars
                              'A striking bird with black and yellow plumage. This bird is known for its vibrant colors and melodic song. It can often be seen in forest edges, woodlands, and gardens, and has a diet that mainly consists of insects and small invertebrates.',
                          large: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Action for the button (to be implemented later)
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

// Fields for bird information
class ProfileField extends StatelessWidget {
  const ProfileField({
    required this.icon,
    required this.label,
    required this.content,
    this.backgroundColor,
    this.padding,
    this.prominent = false,
    this.large = false,
    super.key,
  });

  final IconData icon;
  final String label;
  final String content;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final bool prominent;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color.fromARGB(83, 204, 204, 204),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: BirdPageStyles.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: prominent
                    ? BirdPageStyles.subheading.copyWith(fontSize: 24)
                    : BirdPageStyles.secondaryContent,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: BirdPageStyles.content.copyWith(fontSize: large ? 20 : 18),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
