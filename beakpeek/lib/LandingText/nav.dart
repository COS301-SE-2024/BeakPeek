import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BottomNavItem('Home', 'home.png'),
          BottomNavItem('Map', 'map.png'),
          BottomNavItem('Add Sighting', 'addSighting.png'),
          BottomNavItem('Sightings', 'sightings.png'),
          BottomNavItem('Profile', 'profile.png'),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  const BottomNavItem(this.label, this.file, {super.key});
  final String label;
  final String file;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/icons/$file',
          width: 60,
        ),
        // const SizedBox(height: 1),
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
    );
  }
}