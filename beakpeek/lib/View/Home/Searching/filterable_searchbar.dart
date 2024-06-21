// ignore_for_file: use_key_in_widget_constructors, body_might_complete_normally_nullable, unused_import, lines_longer_than_80_chars, avoid_unnecessary_containers

import 'package:beakpeek/Module/bird.dart';
import 'package:beakpeek/Module/bird_search_functions.dart';

import 'package:dynamic_searchbar/dynamic_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_searchable_dropdown/flutter_searchable_dropdown.dart';
import 'package:searchable_listview/searchable_listview.dart';

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
  List<Widget> items = [];
  final SearchController controller = SearchController();

  @override
  void initState() {
    super.initState();
    items = BirdSearchFunctions().getWidgetListOfBirds(widget.birds);
  }

  void searchBarTyping(String data) {
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchAnchor(
          viewHintText: 'Search Bird...',
          viewOnChanged: (value) => searchBarTyping(value),
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
      ],
    );
  }
}
