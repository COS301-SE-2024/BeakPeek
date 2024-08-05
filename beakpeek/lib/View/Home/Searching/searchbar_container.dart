import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:beakpeek/Model/bird.dart';
import 'package:beakpeek/Controller/DB/database_calls.dart' as db;
import 'package:beakpeek/View/Home/Searching/filterable_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class SearchbarContainer extends StatefulWidget {
  const SearchbarContainer({required this.province, super.key});
  final String province;
  @override
  State<SearchbarContainer> createState() => _SearchcarContainerState();
}

class _SearchcarContainerState extends State<SearchbarContainer> {
  late LifeListProvider lifeList = LifeListProvider.instance;
  late Future<List<Bird>> birds;
  int sort = 0;
  @override
  void initState() {
    super.initState();
    birds = db.fetchAllBirds(widget.province, Client());
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
            }
            return FilterableSearchbar(sort: sort, birds: snapshot.data!);
          },
        ),
      ],
    );
  }
}
