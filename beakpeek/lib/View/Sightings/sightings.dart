// import 'package:beakpeek/View/Login/landing_tab_1.dart';
import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
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

  @override
  void initState() {
    birds = lifeList.fetchLifeList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F1ED),
      body: Column(
        children: [
          const Text('Life List', style: GlobalStyles.subheadingLight),
          FutureBuilder<List<Bird>>(
            future: birds,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }
              return getLiveList(snapshot.data!);
            },
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/home');
            },
            child: const Text(
              'Home',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
