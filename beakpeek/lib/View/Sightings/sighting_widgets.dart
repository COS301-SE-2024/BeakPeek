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

Widget getLifeListData(
    Bird bird, Function(Bird) goBird, BuildContext context, int index) {
  return Container(
    decoration: BoxDecoration(
      color: index % 2 == 1
          ? AppColors.lifelistColor(context)
          : AppColors.popupColor(context),
      borderRadius: BorderRadius.circular(15.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 1),
        ),
      ],
    ),
    margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
    child: ListTile(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      leading: CircleAvatar(
        radius: 25.0,
        backgroundImage:
            const AssetImage('assets/images/profileImages/images.jpg'),
        backgroundColor: Colors.grey[200],
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
    ),
  );
}
