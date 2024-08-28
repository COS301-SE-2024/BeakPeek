// import 'package:beakpeek/View/Login/landing_tab_1.dart';
import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Model/bird_search_functions.dart';
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
  late LifeListProvider lifeList = LifeListProvider.instance;
  late Future<List<Bird>> birds;
  late List<Bird> loaded;

  @override
  void initState() {
    birds = lifeList.fetchLifeList();
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.go('/home');
          },
        ),
        title: const Text('Life List', style: GlobalStyles.subHeadingDark),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Bird>>(
        future: birds,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            if (loaded.isEmpty) {
              setLoaded(snapshot.data!);
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(onPressed: () {}, child: const Text('here')),
                  SizedBox(height: screenHeight * 0.02),
                  ElevatedButton(
                    style: GlobalStyles.elevatedButtonStyle(),
                    onPressed: () {
                      context.go('/home');
                    },
                    child: const Text('Home'),
                  ),
                ],
              ),
            );
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: reportRateASC,
                    child: const Text('Ascending'),
                  ),
                  FilledButton(
                    onPressed: reportRateDESC,
                    child: const Text('Decending'),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  ElevatedButton(
                    style: GlobalStyles.elevatedButtonStyle(),
                    onPressed: () {
                      context.go('/home');
                    },
                    child: const Text('Home'),
                  ),
                ],
              ),
            );
          }
          return SizedBox(
            height: screenHeight * 1,
            child: getLiveList(loaded, goBird),
          );
        },
      ),
    );
  }
}
