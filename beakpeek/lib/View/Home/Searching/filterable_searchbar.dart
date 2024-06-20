// ignore_for_file: use_key_in_widget_constructors, body_might_complete_normally_nullable, unused_import, lines_longer_than_80_chars, avoid_unnecessary_containers

import 'package:beakpeek/Module/bird.dart';
import 'package:beakpeek/Module/bird_search_functions.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class FilterableSearchbar extends StatefulWidget {
  const FilterableSearchbar({super.key, required this.birds});
  const FilterableSearchbar.list(this.birds, {super.key});
  final List<Bird> birds;

  @override
  State<FilterableSearchbar> createState() {
    return FilterableSearchbarState();
  }
}

class FilterableSearchbarState extends State<FilterableSearchbar> {
  @override
  Widget build(BuildContext context) {
    return SearchField(
      suggestions: widget.birds
          .map(
            (bird) => SearchFieldListItem<Bird>(bird.toString(),
                item: bird,
                // Use child to show Custom Widgets in the suggestions
                // defaults to Text widget
                child: BirdSearchFunctions().getData(bird)),
          )
          .toList(),
      hint: 'Search by Bird Name',
      readOnly: true,
      maxSuggestionsInViewPort: 20,
    );
  }
}

// ListView.builder(
//       itemCount: birds.length,
//       itemBuilder: (context, index) {
//         final bird = birds[index];
    // final colorGOYR =
    //     BirdSearchFunctions().getColorForReportingRate(bird.reportingRate);
//         return ListTile(
//           title: Text(bird.commonGroup != 'None'
//               ? '${bird.commonGroup} ${bird.commonSpecies}'
//               : bird.commonSpecies),
//           subtitle: Text('Scientific Name: ${bird.genus} ${bird.species}'),
//           trailing: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('${bird.reportingRate}%'),
//               const SizedBox(width: 8),
//               Container(
//                 width: 20,
//                 height: 20,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: BirdSearchFunctions().colorArray[colorGOYR],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );