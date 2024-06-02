import 'package:beakpeek/map.dart';
import 'package:flutter/material.dart';
import 'package:beakpeek/LandingText/cust_rich_text.dart';
import 'package:beakpeek/LandingText/nav.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFF3F1ED),
        body: home(),
      ),
    );
  }
}

class home extends StatelessWidget {
  const home({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
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
                      const SearchBar(),
                      const SizedBox(height: 20),
                      const CustRichText(
                        'Your Area Map',
                        Color(0xFF033A30),
                        ta: TextAlign.left,
                        fontS: 22,
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: MapSample(),
                      ),
                    ],
                  )
                ),
              ),
            // ),
            const BottomNavigation(),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Image.asset(
          'assets/icons/Logo.png',
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
          
          child:  Row(
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
                child: Image.asset('assets/icons/search.png'),
              ),
            ],
          ),
        )
      ],
    );
  }
}




