import 'package:beakpeek/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:beakpeek/config_azure.dart' as config;

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth / 4; // Divide screen width by number of items

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BottomNavItem('Home', 'home.png', itemWidth),
        BottomNavItem('Map', 'map.png', itemWidth),
        BottomNavItem('Sightings', 'sightings.png', itemWidth),
        BottomNavItem('Profile', 'profile.png', itemWidth),
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
    final iconFile = isDarkMode ? file.replaceAll('.png', 'Dark.png') : file;
    return SizedBox(
      width: itemWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () {
              if (config.loggedIN) {
                context.go('/${label.toLowerCase()}');
              } else {
                if (label.contains('Profile')) {
                  context.go('/');
                } else {
                  context.go('/${label.toLowerCase()}');
                }
              }
            },
            child: Image.asset(
              'assets/icons/$iconFile',
              width: itemWidth * 0.5,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: TextStyle(
              color: AppColors.greyColor(context),
              fontSize: 14,
              fontFamily: 'SF Pro Display',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
