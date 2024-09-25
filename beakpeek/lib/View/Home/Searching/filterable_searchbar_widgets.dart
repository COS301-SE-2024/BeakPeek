import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:flutter/material.dart';

Widget getData(Bird bird, Function goBird, BuildContext context) {
  return ListTile(
    leading: CircleAvatar(
      backgroundImage: NetworkImage(bird.imageUrl ?? ''),
    ),
    title: Text(
      bird.commonGroup.isNotEmpty
          ? '${bird.commonSpecies} ${bird.commonGroup} '
          : bird.commonSpecies,
      style: GlobalStyles.filterTileHeading(context),
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
