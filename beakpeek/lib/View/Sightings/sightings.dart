// import 'package:beakpeek/View/Login/landing_tab_1.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Model/Globals/globals.dart';
import 'package:beakpeek/Model/bird_search_functions.dart';
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
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F1ED),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
          FilledButton(
            onPressed: reportRateASC,
            child: const Text('Ascending'),
          ),
          FilledButton(
            onPressed: reportRateDESC,
            child: const Text('Decending'),
          ),
          SizedBox(
            height: screenHeight * 1,
            child: getLiveList(loaded, goBird, context),
          ),
        ],
      ),
    );
  }
}
