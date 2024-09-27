import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/View/Sightings/sighting_widgets.dart';
import 'package:flutter/material.dart';

List<Widget> getWidgetLifeList(
    List<Bird> birds, Function(Bird) goBird, BuildContext context) {
  final List<Widget> listOfBirdWidgets = [];
  for (var i = 0; i < birds.length; i++) {
    listOfBirdWidgets.add(getLifeListData(birds[i], goBird, context, i));
  }
  return listOfBirdWidgets;
}
