import 'package:flutter/material.dart';
import 'package:beakpeek/LandingText/cust_buttons.dart';
import 'package:beakpeek/LandingText/cust_rich_text.dart';
import 'package:beakpeek/LandingText/nav.dart';

// ignore: camel_case_types
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const SearchBar(),
                      const SizedBox(height: 20),
                      const CustRichText(
                        'Justin\'s Bird of the Day',
                        Color(0xFF033A30),
                        ta: TextAlign.left,
                        fontS: 22,
                      ),
                      // const SizedBox(height: 10),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/images/home.png',
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              color: Colors.black.withOpacity(0.5),
                              child: const CustRichText(
                                'Black Fronted Bushsrike',
                                Colors.white,
                                fontS: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // const SizedBox(height: 30),
                      const CustRichText(
                        'Your Area Map',
                        Color(0xFF033A30),
                        ta: TextAlign.left,
                        fontS: 22,
                      ),
                      const SizedBox(height: 10),
                      Image.asset(
                        'assets/images/map.png',
                      ),
                      // const SizedBox(height: 20),
                      // ignore: lines_longer_than_80_chars
                      // CustOutlinedButton(() {}, 'View Map',Colors.white , const Color(0xFF033A30)),
                      const SizedBox(height: 16),
                      CustButtons(
                        () {} as String,
                        'View Map',
                        const Color(0xFF033A30),
                        Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
          child: Row(
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