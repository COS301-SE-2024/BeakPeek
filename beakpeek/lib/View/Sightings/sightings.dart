import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Model/Globals/globals.dart';
import 'package:beakpeek/Model/BirdInfo/bird_search_functions.dart';
import 'package:beakpeek/Styles/colors.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:beakpeek/View/Sightings/sighting_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:beakpeek/Model/nav.dart';

class Sightings extends StatefulWidget {
  const Sightings({super.key});

  @override
  State<Sightings> createState() {
    return _SightingsState();
  }
}

class _SightingsState extends State<Sightings> {
  late final LifeListProvider lifeList = LifeListProvider.instance;
  late List<Bird> loaded = [];
  late Future<List<Bird>> listBirds;
  String? selectedFilter = 'name';

  @override
  void initState() {
    global.updateLife();
    listBirds = lifeList.fetchLifeList();

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
      global.updateLife();
      loaded = temp;
    });
  }

  void sortAlphaAsc() {
    setLoaded(sortAlphabetically(loaded));
  }

  void sortAlphaDesc() {
    setLoaded(sortAlphabeticallyDesc(loaded));
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
          icon: Icon(Icons.arrow_back, color: AppColors.iconColor(context)),
          onPressed: () {
            context.go('/home');
          },
        ),
        title:
            Text('Life List', style: GlobalStyles.smallHeadingPrimary(context)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Text label for dropdown
                  Text(
                    'Filter by:',
                    style: GlobalStyles.contentPrimary(context),
                  ),
                  const SizedBox(width: 8.0),
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
                  const SizedBox(width: 16.0),
                  // Ascending and Descending buttons
                  Row(
                    children: [
                      SizedBox(
                        width: 80.0,
                        height: 34.0,
                        child: OutlinedButton(
                          style: GlobalStyles.buttonPrimaryOutlined(context),
                          onPressed: () {
                            if (selectedFilter == 'name') {
                              sortAlphaAsc();
                            } else {
                              reportRateASC();
                            }
                          },
                          child: Icon(
                            Icons.arrow_upward,
                            color: AppColors.iconColor(context),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      SizedBox(
                        width: 80.0,
                        height: 34.0,
                        child: OutlinedButton(
                          style: GlobalStyles.buttonPrimaryOutlined(context),
                          onPressed: () {
                            if (selectedFilter == 'name') {
                              sortAlphaDesc();
                            } else {
                              reportRateDESC();
                            }
                          },
                          child: Icon(
                            Icons.arrow_downward,
                            color: AppColors.iconColor(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.75,
            child: FutureBuilder<List<Bird>>(
              future: listBirds,
              builder: (context, snapshot) {
                loaded = snapshot.data!;
                return getLiveList(snapshot.data!, goBird, context);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          const BottomNavigation(), // Add BottomNavigation widget here
    );
  }
}
