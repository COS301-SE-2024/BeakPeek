import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:flutter/material.dart';

// Added BuildContext
Widget getLifeListData(Bird bird, Function(Bird) goBird, BuildContext context) {
  return ListTile(
    title: Text(
      bird.commonGroup.isNotEmpty
          ? '${bird.commonSpecies} ${bird.commonGroup}'
          : bird.commonSpecies,
      style: GlobalStyles.contentPrimary(context),
    ),
    onTap: () {
      goBird(bird);
    },
    subtitle: Text(
      'Scientific Name: ${bird.genus} ${bird.species}',
      style: GlobalStyles.smallContentPrimary(context),
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
