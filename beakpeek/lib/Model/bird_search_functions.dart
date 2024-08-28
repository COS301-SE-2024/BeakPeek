// ignore_for_file: library_prefixes

import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:beakpeek/Model/UserProfile/user_profile_function.dart'
    as upFunc;

final colorArray = [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
];

int getColorForReportingRate(double reportingRate) {
  if (reportingRate < 40.0) {
    return 0;
  } else if (reportingRate < 60.0) {
    return 1;
  } else if (reportingRate < 80.0) {
    return 2;
  } else {
    return 3;
  }
}

Widget getData(Bird bird, LifeListProvider lifeList) {
  return ListTile(
    title: Text(
      bird.commonGroup != 'None'
          ? '${bird.commonGroup} ${bird.commonSpecies}'
          : bird.commonSpecies,
      style: const TextStyle(
        color: AppColors.primaryColorLight,
        fontSize: 16,
      ),
    ),
    subtitle: Text(
      '${bird.genus} ${bird.species}',
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 14,
      ),
    ),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FutureBuilder(
          future: lifeList.isDuplicate(bird),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return FilledButton(
              onPressed: () {
                if (snapshot.data!) {
                  // Handle 'Seen' button action
                } else {
                  upFunc.addExp(20);
                  lifeList.insertBird(bird);
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.secondaryColorLight,
                minimumSize: const Size(10, 30),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                shadowColor: Colors.black.withOpacity(0.5),
              ),
              child: Text(
                snapshot.data! ? 'Seen' : 'Add to Life List',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
}

bool isSeen(Bird bird, LifeListProvider lifeList) {
  late bool seen = false;
  lifeList.isDuplicate(bird).then(
    (value) {
      seen = value;
    },
  );
  return seen;
}

List<Widget> getWidgetListOfBirds(List<Bird> birds) {
  final List<Widget> listOfBirdWidgets = [];
  late final LifeListProvider lifeList = LifeListProvider.instance;

  for (var i = 0; i < birds.length; i++) {
    listOfBirdWidgets.add(getData(birds[i], lifeList));
  }
  return listOfBirdWidgets;
}

List<Bird> sortAlphabetically(List<Bird> birds) {
  birds.sort((a, b) => a.commonGroup.compareTo(b.commonGroup));
  return birds;
}

List<Bird> sortRepotRateDESC(List<Bird> birds) {
  birds.sort((a, b) => b.reportingRate.compareTo(a.reportingRate));
  return birds;
}

List<Bird> searchForBird(List<Bird> birds, String value) {
  final List<Bird> results = birds
      .where((bird) =>
          (bird.commonSpecies).toLowerCase().contains(value.toLowerCase()) ||
          (bird.commonGroup).toLowerCase().contains(value.toLowerCase()))
      .toList();
  return results;
}

List<Bird> getUniqueBirds(List<Bird> birds) {
  final List<String> uniqueBirdKeys = [];
  final List<Bird> uniqueBirds = [];

  for (var bird in birds) {
    final birdKey = '${bird.commonGroup}-${bird.commonSpecies}';
    if (!uniqueBirdKeys.contains(birdKey)) {
      uniqueBirdKeys.add(birdKey);
      uniqueBirds.add(bird);
    } else {
      final int index = uniqueBirdKeys.indexOf(birdKey, 0);
      if (uniqueBirds[index].reportingRate < bird.reportingRate) {
        uniqueBirds[index] = bird;
      }
    }
  }

  return uniqueBirds;
}
