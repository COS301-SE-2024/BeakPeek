import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Model/Globals/globals.dart';
import 'package:beakpeek/Model/BirdInfo/bird_search_functions.dart';
import 'package:beakpeek/Model/UserProfile/user_model.dart';
import 'package:beakpeek/Model/help_icon.dart';
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
    updateOnline();
    global.updateLife();
    loaded = global.birdList;
    super.initState();
  }

  void goBird(Bird bird) {
    context.goNamed(
      'birdInfo',
      pathParameters: {
        'id': bird.id.toString(),
      },
    );
  }

  void setLoaded(List<Bird> temp) {
    setState(() {
      global.updateLife();
      print(loaded);
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
        actions: const [
          HelpIcon(
              content:
                  // ignore: lines_longer_than_80_chars
                  'All birds that you have saved to your life list will appear here. You can easily access all their information by tapping on a tile.\n\nSort the birds you’ve seen by name in ascending or descending order.\n\nYou can return to the home menu by tapping on the arrow in the top left corner.\n\nImport your life list from another app (.csv format only) or export it.'),
          SizedBox(width: 14.0)
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Sort by name:',
                    style: GlobalStyles.contentPrimary(context),
                  ),
                  SizedBox(width: screenWidth * 0.08),
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
                          child: Text(
                            'A-Z',
                            style: GlobalStyles.secondaryButtonText(context),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6.0),
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
                          child: Text(
                            'Z-A',
                            style: GlobalStyles.secondaryButtonText(context),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.75,
            child: FutureBuilder<List<Bird>>(
              future: lifeList.fetchLifeList(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.length > loaded.length) {
                  loaded = snapshot.data!;
                }
                return getLiveList(loaded, goBird, context);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
