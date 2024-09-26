import 'dart:convert';

import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Model/Sightings/sightings_functions.dart';
import 'package:beakpeek/Styles/colors.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:flutter/material.dart';

Widget getLiveList(
    List<Bird> birds, Function(Bird) goBird, BuildContext context) {
  final List<Widget> items = getWidgetLifeList(birds, goBird, context);
  if (items.isEmpty) {
    return Center(
      child: Text(
        '''Time to go spot some birds! \n
            None here yet.''',
        style: GlobalStyles.contentPrimary(context),
      ),
    );
  }
  return ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) {
      return items[index];
    },
  );
}

Widget getLifeListData(Bird bird, Function(Bird) goBird, BuildContext context) {
  final ImageProvider birdImg =
      Image.memory(base64Decode(bird.imageBlob.toString())).image;
  return ListTile(
    tileColor: AppColors.backgroundColor(context),
    leading: CircleAvatar(
      backgroundImage: birdImg,
    ),
    title: Text(
      bird.commonGroup.isNotEmpty
          ? '${bird.commonSpecies} ${bird.commonGroup}'
          : bird.commonSpecies,
      style: GlobalStyles.contentPrimary(context),
    ),
    onTap: () {
      goBird(bird);
    },
  );
}
