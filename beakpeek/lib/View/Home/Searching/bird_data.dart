import 'package:beakpeek/Module/bird.dart';
import 'package:beakpeek/Module/bird_search_functions.dart';
import 'package:flutter/material.dart';

class BirdData extends StatelessWidget {
  const BirdData({super.key, required this.bird});
  final Bird bird;

  @override
  Widget build(BuildContext context) {
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
              color: BirdSearchFunctions().colorArray[BirdSearchFunctions()
                  .getColorForReportingRate(bird.reportingRate)],
            ),
          ),
        ],
      ),
    );
  }
}
