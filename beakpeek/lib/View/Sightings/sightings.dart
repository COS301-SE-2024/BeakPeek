import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Model/Globals/globals.dart';
import 'package:beakpeek/Model/BirdInfo/bird_search_functions.dart';
import 'package:beakpeek/Styles/colors.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:flutter/material.dart';
import 'package:beakpeek/Model/Sightings/sightings_functions.dart';
import 'package:go_router/go_router.dart';

class Sightings extends StatefulWidget {
  const Sightings({super.key});

  @override
  State<Sightings> createState() {
    return _SightingsState();
  }
}

class _SightingsState extends State<Sightings> {
  late List<Bird> loaded = [];
  String? selectedFilter = 'name'; // Add a variable to store the dropdown value

  @override
  void initState() {
    global.updateLife();
    loaded = global.birdList;
    super.initState();
  }

  void goBird(Bird bird) {
    context.goNamed(
      'birdInfo',
      pathParameters: {
        'group': bird.commonGroup,
        'species': bird.commonSpecies,
        'id': bird.id.toString(),
      },
    );
  }

  void setLoaded(List<Bird> temp) {
    setState(() {
      loaded = temp;
    });
  }

  void reportRateDESC() {
    setLoaded(sortRepotRateDESC(loaded));
  }

  void reportRateASC() {
    setLoaded(sortRepotRateASC(loaded));
  }

  void onFilterChanged(String? newValue) {
    setState(() {
      selectedFilter = newValue;
    });

    if (selectedFilter == 'rarity') {
    } else if (selectedFilter == 'name') {}
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor(context),
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor(context),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.iconColor(context)),
            onPressed: () {
              context.go('/home');
            },
          ),
          title: Text('Life List',
              style: GlobalStyles.smallHeadingPrimary(context)),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Dropdown Button
                  DropdownButton<String>(
                    dropdownColor: AppColors.popupColor(context),
                    value: selectedFilter,
                    items: [
                      DropdownMenuItem(
                        value: 'name',
                        child: Text(
                          'Name',
                          style: GlobalStyles.contentPrimary(context),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'rarity',
                        child: Text(
                          'Rarity',
                          style: GlobalStyles.contentPrimary(context),
                        ),
                      ),
                    ],
                    onChanged: onFilterChanged,
                    style: GlobalStyles.primaryButtonText(context),
                    underline: Container(),
                  ),
                  // Ascending button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: SizedBox(
                          width: 80.0,
                          height: 34.0,
                          child: OutlinedButton(
                            style: GlobalStyles.buttonPrimaryOutlined(context),
                            onPressed: reportRateASC,
                            child: Icon(
                              Icons.arrow_upward,
                              color: AppColors.iconColor(context),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 80.0,
                        height: 34.0,
                        child: OutlinedButton(
                          style: GlobalStyles.buttonPrimaryOutlined(context),
                          onPressed: reportRateDESC,
                          child: Icon(
                            Icons.arrow_downward,
                            color: AppColors.iconColor(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Descending button
                ],
              ),
            ),
            SizedBox(
              height: screenHeight * 0.75,
              child: getLiveList(loaded, goBird, context),
            ),
          ],
        ),
      ),
    );
  }
}
