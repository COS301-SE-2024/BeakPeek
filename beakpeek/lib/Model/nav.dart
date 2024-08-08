import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth / 5; // Divide screen width by number of items

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BottomNavItem('Home', 'home.png', itemWidth),
        BottomNavItem('Map', 'map.png', itemWidth),
        BottomNavItem('Bird', 'addSighting.png', itemWidth),
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
    return SizedBox(
      width: itemWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () {
              context.go('/${label.toLowerCase()}');
            },
            child: Image.asset(
              'assets/icons/$file',
              width: itemWidth * 0.5,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
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
