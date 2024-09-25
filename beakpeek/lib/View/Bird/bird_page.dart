// ignore_for_file: library_private_types_in_public_api

import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:beakpeek/Controller/Home/sound_controller.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Model/BirdInfo/bird_search_functions.dart';
import 'package:beakpeek/Model/Globals/globals.dart';
import 'package:beakpeek/Model/bird_page_functions.dart';
import 'package:beakpeek/Styles/colors.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:beakpeek/Model/nav.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:beakpeek/Model/UserProfile/user_profile_function.dart'
    as up_func;

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
  late String seenText;
  late final LifeListProvider lifeList = LifeListProvider.instance;

  @override
  void initState() {
    seenText = isSeenGS(widget.commonGroup, widget.commonSpecies)
        ? 'Seen'
        : 'Add to Life List';
    global.updateLife();
    super.initState();
    birdFuture = ApiService().fetchBirdInfoOffline(lifeList, widget.id);
  }

  void addToLifeList() {
    if (!isSeenGS(widget.commonGroup, widget.commonSpecies)) {
      setState(
        () {
          seenText = 'Seen';
          up_func.addExp(20);
          global.updateLife();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    String seenText = isSeenGS(widget.commonGroup, widget.commonSpecies)
        ? 'Seen'
        : 'Add to Life List';

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
            context.pop();
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
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<Map<String, dynamic>?>(
                future: birdFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: AppColors.primaryColor(context),
                    ));
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text('Failed to load bird info'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('No bird info found'));
                  }
                  final birdData = snapshot.data!;
                  return Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.02),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            '''${birdData['commonSpecies']} ${birdData['commonGroup']}''',
                            style: GlobalStyles.smallHeadingPrimary(context),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Row(
                          children: [
                            BirdSoundPlayer(
                                commonGroup: widget.commonGroup,
                                commonSpecies: widget.commonSpecies),
                            const SizedBox(width: 8),
                            Text(
                              'Play Bird Call',
                              style: GlobalStyles.smallContentPrimary(context)
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
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
                                birdData['image_Url'],
                                width: screenWidth * 0.92,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Expanded(
                          child: Container(
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
                                    Text(
                                      'Description',
                                      style: GlobalStyles.smallHeadingPrimary(
                                          context),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Text(
                                      birdData['info'] ??
                                          'No description available',
                                      style:
                                          GlobalStyles.contentPrimary(context)
                                              .copyWith(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  SizedBox(
                    width: screenWidth * 0.8,
                    child: FilledButton(
                      onPressed: () {
                        up_func.addExp(20);
                        global.lifeList.insertBird(Bird(
                            id: widget.id,
                            commonGroup: widget.commonGroup,
                            commonSpecies: widget.commonSpecies,
                            genus: 'genus',
                            species: 'species',
                            fullProtocolRR: 0.0,
                            fullProtocolNumber: 0,
                            latestFP: '',
                            jan: 0,
                            feb: 0,
                            mar: 0,
                            apr: 0,
                            may: 0,
                            jun: 0,
                            jul: 0,
                            aug: 0,
                            sep: 0,
                            oct: 0,
                            nov: 0,
                            dec: 0,
                            totalRecords: 0,
                            reportingRate: 0.0));
                        global.updateLife();
                        setState(() {
                          seenText =
                              isSeenGS(widget.commonGroup, widget.commonSpecies)
                                  ? 'Seen'
                                  : 'Add to Life List';
                        });
                      },
                      style: GlobalStyles.buttonPrimaryFilled(context).copyWith(
                        shadowColor: WidgetStateProperty.all(
                            Colors.black.withOpacity(0.15)),
                        elevation: WidgetStateProperty.all(6.0),
                      ),
                      child: Text(
                        seenText,
                        style: GlobalStyles.primaryButtonText(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    width: screenWidth * 0.8,
                    child: OutlinedButton(
                      style: GlobalStyles.buttonPrimaryFilled(context).copyWith(
                        shadowColor: WidgetStateProperty.all(
                            Colors.black.withOpacity(0.15)),
                        elevation: WidgetStateProperty.all(6.0),
                      ),
                      child: Text('Show Heat Map',
                          style: GlobalStyles.primaryButtonText(context)),
                      onPressed: () {
                        context.go('/heatmap/${widget.id}');
                      },
                    ),
                  ),
                  const BottomNavigation(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
