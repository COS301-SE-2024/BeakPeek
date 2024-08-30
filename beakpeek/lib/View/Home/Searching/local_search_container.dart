import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Controller/DB/database_calls.dart' as db;
import 'package:beakpeek/View/Home/Searching/local_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class LocalSearchContainer extends StatefulWidget {
  const LocalSearchContainer(
      {required this.province, required this.helpContent, super.key});
  final String province;
  final String helpContent;

  @override
  State<LocalSearchContainer> createState() => _LocalSearchContainerState();
}

class _LocalSearchContainerState extends State<LocalSearchContainer> {
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
              return const SizedBox.shrink(); // Hide when loading
            } else if (snapshot.hasError) {
              // return Center(child: Text('Error: ${snapshot.error}'));
              return const Center(child: Text('')); // Removed error message for
            }
            return LocalSearch(sort: sort, birds: snapshot.data!);
          },
        ),
      ],
    );
  }
}
