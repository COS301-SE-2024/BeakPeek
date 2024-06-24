import 'package:beakpeek/Model/bird.dart';
import 'package:beakpeek/Controller/DB/database_calls.dart' as db;
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
  int sort = 0;
  @override
  void initState() {
    super.initState();
    birds = db
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
            return FilterableSearchbar(sort: sort, birds: snapshot.data!);
          },
        ),
      ],
    );
  }
}
