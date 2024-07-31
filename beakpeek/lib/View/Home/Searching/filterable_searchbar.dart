import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:beakpeek/Model/bird.dart';
import 'package:beakpeek/Model/bird_search_functions.dart' as bsf;
import 'package:flutter/material.dart';

class FilterableSearchbar extends StatefulWidget {
  const FilterableSearchbar(
      {super.key, required this.birds, required this.sort});
  final List<Bird> birds;
  final int sort;

  @override
  State<FilterableSearchbar> createState() {
    return FilterableSearchbarState();
  }
}

class FilterableSearchbarState extends State<FilterableSearchbar> {
  late LifeListProvider lifeList = LifeListProvider.instance;
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
        Row(
          children: [
            Expanded(
              child: SearchAnchor(
                viewHintText: 'Search Bird...',
                viewOnChanged: (value) {
                  searchBarTyping(value);
                },
                builder: (context, controller) {
                  return const Row(
                    children: [
                      Icon(Icons.search),
                      SizedBox(width: 5),
                      Text('Search'),
                    ],
                  );
                },
                suggestionsBuilder: (context, controller) {
                  return items;
                },
              ),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  temp = bsf.sortAlphabetically(widget.birds);
                  items = bsf.getWidgetListOfBirds(temp);
                });
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color.fromARGB(178, 3, 58, 48),
                minimumSize: const Size(60, 30),
                shadowColor: Colors.black,
              ),
              child: const Text(
                'A-Z',
              ),
            ),
            const SizedBox(width: 5),
            FilledButton(
              onPressed: () {
                setState(() {
                  temp = bsf.sortRepotRateDESC(widget.birds);
                  items = bsf.getWidgetListOfBirds(temp);
                });
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color.fromARGB(178, 3, 58, 48),
                minimumSize: const Size(60, 30),
                shadowColor: Colors.black,
              ),
              child: const Text(
                'Report Rate',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
