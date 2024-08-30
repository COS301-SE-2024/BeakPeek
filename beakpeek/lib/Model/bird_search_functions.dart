import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Model/Globals/globals.dart';
import 'package:beakpeek/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:beakpeek/Model/UserProfile/user_profile_function.dart'
    as up_func;

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

Widget getData(Bird bird, Function goBird) {
  final bool seen = isSeen(bird);
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
      style: const TextStyle(
        color: Color.fromARGB(255, 0, 0, 0),
        fontSize: 14,
      ),
    ),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('${bird.reportingRate}%'),
        const SizedBox(width: 8),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorArray[getColorForReportingRate(bird.reportingRate)],
          ),
        ),
        const SizedBox(width: 10),
        FilledButton(
          onPressed: () {
            if (seen) {
              goBird(bird);
            } else {
              up_func.addExp(20);
              global.lifeList.insertBird(bird);
              global.updateLife();
              goBird(bird);
            }
          },
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.secondaryColorLight,
            minimumSize: const Size(128, 30),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            shadowColor: Colors.black.withOpacity(0.5),
          ),
          child: Text(
            seen ? 'Seen' : 'Add to Life List',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ],
    ),
    onTap: () {
      goBird(bird);
    },
  );
}

bool isSeen(Bird bird) {
  var temp = global.birdList.where((test) =>
      test.commonGroup
              .toLowerCase()
              .compareTo(bird.commonGroup.toLowerCase()) ==
          0 &&
      test.commonSpecies
              .toLowerCase()
              .compareTo(bird.commonSpecies.toLowerCase()) ==
          0 &&
      test.genus.toLowerCase().compareTo(bird.genus.toLowerCase()) == 0);
  if (temp.isNotEmpty) {
    return true;
  }
  return false;
}

List<Widget> getWidgetListOfBirds(List<Bird> birds, Function goBird) {
  final List<Widget> listOfBirdWidgets = [];

  for (var i = 0; i < birds.length; i++) {
    listOfBirdWidgets.add(getData(birds[i], goBird));
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

List<Bird> sortRepotRateASC(List<Bird> birds) {
  birds.sort((a, b) => a.reportingRate.compareTo(b.reportingRate));
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
