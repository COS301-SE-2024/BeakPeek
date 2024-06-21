// ignore_for_file: use_key_in_widget_constructors, body_might_complete_normally_nullable, unused_import, lines_longer_than_80_chars, avoid_unnecessary_containers

import 'package:beakpeek/Model/bird.dart';
import 'package:beakpeek/Model/bird_search_functions.dart';

import 'package:dynamic_searchbar/dynamic_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_searchable_dropdown/flutter_searchable_dropdown.dart';
import 'package:searchable_listview/searchable_listview.dart';

class FilterableSearchbar extends StatefulWidget {
  const FilterableSearchbar(
      {super.key, required this.birds, required this.sort});
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
    items = BirdSearchFunctions().getWidgetListOfBirds(widget.birds);
  }

  void searchBarTyping(String data) {
    if (data.isEmpty) {
      items = BirdSearchFunctions().getWidgetListOfBirds(widget.birds);
    } else {
      temp = BirdSearchFunctions().searchForBird(widget.birds, data);
      items = BirdSearchFunctions().getWidgetListOfBirds(temp);
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
                    temp =
                        BirdSearchFunctions().sortAlphabetically(widget.birds);
                    items = BirdSearchFunctions().getWidgetListOfBirds(temp);
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
                    temp =
                        BirdSearchFunctions().sortRepotRateDESC(widget.birds);
                    items = BirdSearchFunctions().getWidgetListOfBirds(temp);
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
