// ignore_for_file: use_key_in_widget_constructors, body_might_complete_normally_nullable, unused_import, lines_longer_than_80_chars, avoid_unnecessary_containers

import 'package:beakpeek/Module/bird.dart';
import 'package:beakpeek/Module/bird_search_functions.dart';

import 'package:dynamic_searchbar/dynamic_searchbar.dart';
import 'package:flutter/material.dart';

class FilterableSearchbar extends StatefulWidget {
  const FilterableSearchbar(
      {super.key, required this.birds, required this.sort});
  // coverage:ignore-line
  const FilterableSearchbar.list(this.birds, this.sort, {super.key});
  final List<Bird> birds;
  final int sort;

  @override
  State<FilterableSearchbar> createState() {
    return FilterableSearchbarState();
  }
}

class FilterableSearchbarState extends State<FilterableSearchbar> {
  List<Widget> items = [];
  final SearchController controller = SearchController();
  List<Bird> temp = [];
  @override
  void initState() {
    super.initState();
    items = bsf.getWidgetListOfBirds(widget.birds);
  }

  void searchBarTyping(String data) {
    if (data.isEmpty) {
      items = bsf.getWidgetListOfBirds(widget.birds);
    } else {
      temp = bsf.searchForBird(widget.birds, data);
      items = bsf.getWidgetListOfBirds(temp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchAnchor(
          viewHintText: 'Search Bird...',
          viewOnChanged: (value) {
            setState(() {
              searchBarTyping(value);
            });
          },
          builder: (context, controller) {
            return IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                controller.openView();
              },
            );
          },
          suggestionsBuilder: (context, controller) {
            return items;
          },
        ),
        Row(
          children: [
            FilledButton(
              onPressed: () {
                setState(
                  () {
                    temp = bsf.sortAlphabetically(widget.birds);
                    items = bsf.getWidgetListOfBirds(temp);
                  },
                );
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size(50, 50),
                shadowColor: Colors.black,
              ),
              child: const Text(
                'A-Z',
              ),
            ),
            FilledButton(
              onPressed: () {
                setState(
                  () {
                    temp = bsf.sortRepotRateDESC(widget.birds);
                    items = bsf.getWidgetListOfBirds(temp);
                  },
                );
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size(50, 50),
                shadowColor: Colors.black,
              ),
              child: const Text(
                'ReportRate',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
