// ignore_for_file: library_private_types_in_public_api

import 'package:beakpeek/Controller/Home/sound_controller.dart';
import 'package:beakpeek/Model/bird_page_functions.dart';
import 'package:beakpeek/Styles/colors.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:beakpeek/Model/nav.dart';
import 'package:beakpeek/View/Map/heat_map.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BirdPage extends StatefulWidget {
  // ignore: lines_longer_than_80_chars
  const BirdPage(
      {super.key,
      required this.commonGroup,
      required this.commonSpecies,
      required this.id});

  final String commonGroup;
  final String commonSpecies;
  final int id;

  @override
  _BirdPageState createState() => _BirdPageState();
}

class _BirdPageState extends State<BirdPage> {
  late Future<Map<String, dynamic>?> birdFuture;

  @override
  void initState() {
    super.initState();
    birdFuture =
        ApiService().fetchBirdInfo(widget.commonGroup, widget.commonSpecies);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.iconColor(context),
          ),
          onPressed: () {
            context.go('/home');
          },
        ),
        title: Text(
          'Bird Information',
          style: GlobalStyles.smallHeadingPrimary(context),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.zero,
        child: Center(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      child: FutureBuilder<Map<String, dynamic>?>(
                        future: birdFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: CircularProgressIndicator(
                              color: AppColors.primaryColor(context),
                            ));
                          } else if (snapshot.hasError) {
                            return const Center(
                                child: Text('Failed to load bird info'));
                          } else if (!snapshot.hasData) {
                            return const Center(
                                child: Text('No bird info found'));
                          }

                          final birdData = snapshot.data!;
                          return Column(
                            children: [
                              SizedBox(height: screenHeight * 0.02),
                              Row(
                                children: [
                                  const SizedBox(width: 16.0),
                                  Text(
                                    birdData['name'],
                                    style: GlobalStyles.smallHeadingPrimary(
                                        context),
                                  ),
                                  const SizedBox(width: 16.0),
                                  BirdSoundPlayer(
                                      commonGroup: widget.commonGroup,
                                      commonSpecies: widget.commonSpecies),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              Center(
                                child: Container(
                                  width: screenWidth * 0.92,
                                  height: screenWidth * 0.5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 3,
                                        blurRadius: 5,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      birdData['images'][1]['url'],
                                      width: screenWidth * 0.92,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              Container(
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: AppColors.popupColor(context),
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 3,
                                      blurRadius: 5,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.description,
                                          color: AppColors.iconColor(context),
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text('Description',
                                            style: GlobalStyles
                                                .smallHeadingPrimary(context)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      birdData['description'] ??
                                          'No description available',
                                      style:
                                          GlobalStyles.contentPrimary(context)
                                              .copyWith(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            body: HeatMap(
                              id: widget.id,
                            ),
                          ),
                        ),
                      );
                    },
                    style: GlobalStyles.buttonPrimaryFilled(context),
                    child: const Text('Show Heat Map'),
                  ),
                ),
                const BottomNavigation(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
