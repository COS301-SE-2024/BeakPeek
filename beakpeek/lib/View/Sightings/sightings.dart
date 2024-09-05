// import 'package:beakpeek/View/Login/landing_tab_1.dart';
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: screenWidth * 0.42,
                  child: OutlinedButton(
                    style: GlobalStyles.buttonPrimaryFilled(context),
                    onPressed: reportRateASC,
                    child: Text('Ascending',
                        style: GlobalStyles.primaryButtonText(context)),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.42,
                  child: OutlinedButton(
                    style: GlobalStyles.buttonPrimaryFilled(context),
                    onPressed: reportRateDESC,
                    child: Text('Descending',
                        style: GlobalStyles.primaryButtonText(context)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: screenHeight * 0.75,
            child: getLiveList(loaded, goBird, context),
          ),
        ],
      ),
    );
  }
}
