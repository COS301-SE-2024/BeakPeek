import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/View/Sightings/sighting_widgets.dart';
import 'package:flutter/material.dart';

List<Widget> getWidgetLifeList(
    List<Bird> birds, Function(Bird) goBird, BuildContext context) {
  final List<Widget> listOfBirdWidgets = [];
  int i = 0;
  for (Bird temp in birds) {
    listOfBirdWidgets.add(getLifeListData(temp, goBird, context, i));
    i++;
  }
  return listOfBirdWidgets;
}
