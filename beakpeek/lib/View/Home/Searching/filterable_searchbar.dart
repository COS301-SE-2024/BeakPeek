// ignore_for_file: must_be_immutable

import 'package:beakpeek/Module/bird.dart';
import 'package:beakpeek/Module/bird_search_functions.dart';
import 'package:flutter/material.dart';

class FilterableSearchbar extends StatelessWidget {
  const FilterableSearchbar({super.key, required this.birds});
  final List<Bird> birds;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: birds.length,
      itemBuilder: (context, index) {
        final bird = birds[index];
        final colorGOYR =
            BirdSearchFunctions().getColorForReportingRate(bird.reportingRate);
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
                  color: BirdSearchFunctions().colorArray[colorGOYR],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
