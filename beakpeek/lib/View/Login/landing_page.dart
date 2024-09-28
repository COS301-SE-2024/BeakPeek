import 'package:beakpeek/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:beakpeek/View/Login/landing_tab_1.dart';
import 'package:beakpeek/View/Login/landing_tab_2.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F1ED),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: [
              LandingTab1(
                pageController: _pageController,
              ),
              const LandingTab2(),
            ],
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 2,
                effect: ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: AppColors.tertiaryColor(context),
                  dotColor: AppColors.greyColor(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
