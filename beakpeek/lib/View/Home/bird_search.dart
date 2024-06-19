// ignore_for_file: avoid_print, lines_longer_than_80_chars, must_be_immutable

import 'package:beakpeek/Module/bird.dart';
import 'package:beakpeek/Module/bird_search_functions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BirdSearch extends StatefulWidget {
  const BirdSearch({super.key});

  @override
  State<BirdSearch> createState() => _BirdListState();
}

class _BirdListState extends State<BirdSearch> {
  late Future<List<Bird>> birds;
  @override
  void initState() {
    super.initState();
    birds = BirdSearchFunctions().fetchAllBirds(
        http.Client()); // Fetch and sort birds from the API initially
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Bird>>(
              future: birds,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No birds found.'));
                }
                return BirdList(birds: snapshot.data!);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BirdList extends StatelessWidget {
  const BirdList({super.key, required this.birds});
  final List<Bird> birds;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: birds.length,
      itemBuilder: (context, index) {
        final bird = birds[index];
        final colorGOYR =
            BirdSearchFunctions().getColorForReportingRate(bird.reportingRate);
        return ListTile(
          title: Text(bird.commonGroup != 'None'
              ? '${bird.commonGroup} ${bird.commonSpecies}'
              : bird.commonSpecies),
          subtitle: Text('Scientific Name: ${bird.genus} ${bird.species}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${bird.reportingRate}%'),
              const SizedBox(width: 8),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: BirdSearchFunctions().colorArray[colorGOYR],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
