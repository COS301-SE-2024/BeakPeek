import 'package:beakpeek/Module/bird.dart';
import 'package:beakpeek/Module/bird_search_functions.dart';
import 'package:beakpeek/View/Home/Searching/filterable_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class SearchbarContainer extends StatefulWidget {
  const SearchbarContainer({super.key});

  @override
  State<SearchbarContainer> createState() => _SearchcarContainerState();
}

class _SearchcarContainerState extends State<SearchbarContainer> {
  late Future<List<Bird>> birds;
  @override
  void initState() {
    super.initState();
    birds = BirdSearchFunctions()
        .fetchAllBirds(Client()); // Fetch and sort birds from the API initially
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<List<Bird>>(
            future: birds,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No birds found.'));
              }
              //print(snapshot.data!);
              return FilterableSearchbar(birds: snapshot.data!);
            }),
        Row(
          children: [
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                minimumSize: const Size(50, 50),
                shadowColor: Colors.black,
              ),
              child: const Text(
                'A-Z',
              ),
            ),
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                minimumSize: const Size(50, 50),
                shadowColor: Colors.black,
              ),
              child: const Text(
                'ReportRate',
              ),
            ),
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                minimumSize: const Size(50, 50),
                shadowColor: Colors.black,
              ),
              child: const Text(
                'Region',
              ),
            ),
          ],
        ),
      ],
    );
  }
}