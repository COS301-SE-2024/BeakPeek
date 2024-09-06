import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Model/Globals/globals.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:flutter/material.dart';

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

Widget getData(Bird bird, Function goBird, BuildContext context) {
  return ListTile(
    title: Text(
      bird.commonGroup.isNotEmpty
          ? '${bird.commonGroup} ${bird.commonSpecies}'
          : bird.commonSpecies,
      style: GlobalStyles.filterTileHeading(context),
    ),
    subtitle: Text(
      '${bird.genus} ${bird.species}',
      style: GlobalStyles.filterTileSubHeading(context),
    ),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 10),
        FilledButton(
          onPressed: () {
            goBird(bird);
          },
          style: GlobalStyles.buttonFilterPrimaryFilled(context).copyWith(
            elevation: WidgetStateProperty.all(2),
          ),
          child: Text('View Bird',
              style: GlobalStyles.smallContentPrimary(context)
                  .copyWith(color: Colors.white)),
        ),
      ],
    ),
    onTap: () {
      goBird(bird);
    },
  );
}

bool isSeen(Bird bird) {
  final temp = global.birdList.where((test) =>
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

bool isSeenGS(String group, String species) {
  final temp = global.birdList.where((test) =>
      test.commonGroup.toLowerCase().compareTo(group.toLowerCase()) == 0 &&
      test.commonSpecies.toLowerCase().compareTo(species.toLowerCase()) == 0);
  if (temp.isNotEmpty) {
    return true;
  }
  return false;
}

List<Widget> getWidgetListOfBirds(
    List<Bird> birds, Function goBird, BuildContext context) {
  final List<Widget> listOfBirdWidgets = [];

  for (var i = 0; i < birds.length; i++) {
    listOfBirdWidgets.add(getData(birds[i], goBird, context));
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
