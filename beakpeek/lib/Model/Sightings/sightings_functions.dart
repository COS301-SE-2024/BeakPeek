import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Model/bird_search_functions.dart';
import 'package:flutter/material.dart';

Widget getLifeListData(Bird bird) {
  return ListTile(
    title: Text(
      bird.commonGroup.isNotEmpty
          ? '${bird.commonGroup} ${bird.commonSpecies}'
          : bird.commonSpecies,
      style: const TextStyle(color: Color.fromARGB(255, 177, 88, 88)),
    ),
    subtitle: Text(
      'Scientific Name: ${bird.genus} ${bird.species}',
      style: const TextStyle(color: Colors.black),
    ),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${bird.reportingRate}%',
          style: const TextStyle(color: Colors.black),
        ),
        const SizedBox(width: 8),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorArray[getColorForReportingRate(bird.reportingRate)],
          ),
        ),
      ],
    ),
  );
}

List<Widget> getWidgetLifeList(List<Bird> birds) {
  final List<Widget> listOfBirdWidgets = [];
  for (var i = 0; i < birds.length; i++) {
    listOfBirdWidgets.add(getLifeListData(birds[i]));
  }
  return listOfBirdWidgets;
}

Widget getLiveList(List<Bird> birds) {
  final List<Widget> items = getWidgetLifeList(birds);
  if (items.isEmpty) {
    return const Text(
      'NO Birds Seen',
      style: TextStyle(color: Colors.black),
    );
  }
  return SizedBox(
    height: 200,
    child: ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return items[index];
      },
    ),
  );
}
