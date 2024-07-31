import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:beakpeek/Model/bird.dart';
import 'package:beakpeek/Model/bird_search_functions.dart' as bsf;
import 'package:flutter/material.dart';

class FilterableSearchbar extends StatefulWidget {
  const FilterableSearchbar({
    super.key,
    required this.birds,
    required this.sort,
  });

  final List<Bird> birds;
  final int sort;

  @override
  State<FilterableSearchbar> createState() {
    return _FilterableSearchbarState();
  }
}

class _FilterableSearchbarState extends State<FilterableSearchbar> {
  late final LifeListProvider lifeList = LifeListProvider.instance;
  List<Widget> items = [];
  final SearchController controller = SearchController();
  late List<Bird> filteredBirds;

  @override
  void initState() {
    super.initState();
    filteredBirds = widget.birds;
    items = bsf.getWidgetListOfBirds(filteredBirds);
  }

  void searchBarTyping(String data) {
    setState(() {
      filteredBirds =
          data.isEmpty ? widget.birds : bsf.searchForBird(widget.birds, data);
      items = bsf.getWidgetListOfBirds(filteredBirds);
    });
  }

  void sortAlphabetically() {
    setState(() {
      filteredBirds = bsf.sortAlphabetically(filteredBirds);
      items = bsf.getWidgetListOfBirds(filteredBirds);
    });
  }

  void sortByReportingRate() {
    setState(() {
      filteredBirds = bsf.sortRepotRateDESC(filteredBirds);
      items = bsf.getWidgetListOfBirds(filteredBirds);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SearchAnchor(
                searchController: controller,
                viewHintText: 'Search Bird...',
                viewOnChanged: searchBarTyping,
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
            const SizedBox(width: 10),
            FilledButton(
              onPressed: sortAlphabetically,
              style: FilledButton.styleFrom(
                backgroundColor: const Color.fromARGB(178, 3, 58, 48),
                minimumSize: const Size(60, 30),
                shadowColor: Colors.black,
              ),
              child: const Text('A-Z'),
            ),
            const SizedBox(width: 10),
            FilledButton(
              onPressed: sortByReportingRate,
              style: FilledButton.styleFrom(
                backgroundColor: const Color.fromARGB(178, 3, 58, 48),
                minimumSize: const Size(100, 30),
                shadowColor: Colors.black,
              ),
              child: const Text('Report Rate'),
            ),
          ],
        ),
      ],
    );
  }
}
