import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

// Added BuildContext
Widget getLifeListData(Bird bird, Function(Bird) goBird, BuildContext context) {
  return ListTile(
    title: Text(
      bird.commonGroup.isNotEmpty
          ? '${bird.commonGroup} ${bird.commonSpecies}'
          : bird.commonSpecies,
      style: TextStyle(color: AppColors.primaryColor(context)),
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

// Added BuildContext
List<Widget> getWidgetLifeList(
    List<Bird> birds, Function(Bird) goBird, BuildContext context) {
  final List<Widget> listOfBirdWidgets = [];
  for (var i = 0; i < birds.length; i++) {
    listOfBirdWidgets.add(getLifeListData(birds[i], goBird, context));
  }
  return listOfBirdWidgets;
}

// Added BuildContext
Widget getLiveList(
    List<Bird> birds, Function(Bird) goBird, BuildContext context) {
  final List<Widget> items = getWidgetLifeList(birds, goBird, context);
  if (items.isEmpty) {
    return const Text(
      'No birds seen...',
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
