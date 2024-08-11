import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:flutter/material.dart';

Widget getLifeListData(Bird bird, Function(Bird) goBird) {
  return ListTile(
    title: Text(
      bird.commonGroup.isNotEmpty
          ? '${bird.commonGroup} ${bird.commonSpecies}'
          : bird.commonSpecies,
      style: const TextStyle(color: Color.fromARGB(255, 177, 88, 88)),
    ),
    onTap: () {
      goBird(bird);
    },
    subtitle: Text(
      'Scientific Name: ${bird.genus} ${bird.species}',
      style: const TextStyle(color: Colors.black),
    ),
  );
}

List<Widget> getWidgetLifeList(List<Bird> birds, Function(Bird) goBird) {
  final List<Widget> listOfBirdWidgets = [];
  for (var i = 0; i < birds.length; i++) {
    listOfBirdWidgets.add(getLifeListData(birds[i], goBird));
  }
  return listOfBirdWidgets;
}

Widget getLiveList(List<Bird> birds, Function(Bird) goBird) {
  final List<Widget> items = getWidgetLifeList(birds, goBird);
  if (items.isEmpty) {
    return const Text(
      'NO Birds Seen',
      style: TextStyle(color: Colors.black),
    );
  }
  return ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) {
      return items[index];
    },
  );
}
