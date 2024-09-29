import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    double itemWidth;
    double iconSize;

    if (screenWidth < 600) {
      itemWidth = screenWidth / 5;
      iconSize = itemWidth * 0.5;
    } else if (screenWidth < 900) {
      itemWidth = screenWidth / 6;
      iconSize = itemWidth * 0.4;
    } else {
      itemWidth = screenWidth / 7;
      iconSize = itemWidth * 0.35;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BottomNavItem('Home', 'home.svg', itemWidth, iconSize),
        BottomNavItem('Map', 'map.svg', itemWidth, iconSize),
        BottomNavItem('Sightings', 'sightings.svg', itemWidth, iconSize),
        BottomNavItem('Achievements', 'achievements.svg', itemWidth, iconSize),
        BottomNavItem('Profile', 'profile.svg', itemWidth, iconSize),
      ],
    );
  }
}

class BottomNavItem extends StatelessWidget {
  const BottomNavItem(this.label, this.file, this.itemWidth, this.iconSize,
      {super.key});

  final String label;
  final String file;
  final double itemWidth;
  final double iconSize;

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
              context.goNamed(label.toLowerCase());
            },
            child: SvgPicture.asset(
              'assets/icons/$iconFile',
              width: iconSize,
            ),
          ),
        ],
      ),
    );
  }
}
