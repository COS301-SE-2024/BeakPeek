import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:beakpeek/Model/bird.dart';
import 'package:flutter/material.dart';

final colorArray = [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
];

int getColorForReportingRate(double reportingRate) {
  if (reportingRate < 40) {
    return 0;
  } else if (reportingRate < 60) {
    return 1;
  } else if (reportingRate < 80) {
    return 2;
  } else {
    return 3;
  }
}

Widget getData(Bird bird, LifeListProvider lifeList) {
  return ListTile(
    title: Text(bird.commonGroup != 'None'
        ? '${bird.commonGroup} ${bird.commonSpecies}'
        : bird.commonSpecies),
    subtitle: Text('Scientific Name: ${bird.genus} ${bird.species}'),
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
        FutureBuilder(
          future: lifeList.isDuplicate(bird),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.data!) {
              return FilledButton(
                onPressed: () => {},
                child: const Text('Seen'),
              );
            } else {
              return FilledButton(
                onPressed: () => {
                  lifeList.insertBird(bird),
                },
                child: const Text('Add To Life list'),
              );
            }
          },
        ),
      ],
    ),
  );
}

bool isSeen(Bird bird, LifeListProvider lifeList) {
  // ignore: prefer_const_declarations
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
