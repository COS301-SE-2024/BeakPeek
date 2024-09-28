import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:beakpeek/config_azure.dart' as config;
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth / 5;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BottomNavItem('Home', 'home.svg', itemWidth),
        BottomNavItem('Map', 'map.svg', itemWidth),
        BottomNavItem('Sightings', 'sightings.svg', itemWidth),
        BottomNavItem('Achievements', 'achievements.svg', itemWidth),
        BottomNavItem('Profile', 'profile.svg', itemWidth),
      ],
    );
  }
}

class BottomNavItem extends StatelessWidget {
  const BottomNavItem(this.label, this.file, this.itemWidth, {super.key});
  final String label;
  final String file;
  final double itemWidth;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconFile = isDarkMode ? file.replaceAll('.svg', 'Dark.svg') : file;
    return SizedBox(
      width: itemWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () {
              if (label.toLowerCase().compareTo('home') == 0) {
                context.goNamed('home');
              }
              if (config.loggedIN) {
                context.goNamed(label.toLowerCase());
              } else {
                if (label.contains('Profile')) {
                  context.go('/');
                } else {
                  context.goNamed(label.toLowerCase());
                }
              }
            },
            child: SvgPicture.asset(
              'assets/icons/$iconFile',
              width: itemWidth * 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
