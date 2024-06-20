// ignore_for_file: avoid_print, lines_longer_than_80_chars, must_be_immutable

import 'package:beakpeek/Module/bird.dart';
import 'package:beakpeek/Module/bird_search_functions.dart';
import 'package:beakpeek/View/Home/Searching/bird_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BirdSearch extends StatefulWidget {
  const BirdSearch({super.key});

  @override
  State<BirdSearch> createState() => _BirdSearchState();
}

class _BirdSearchState extends State<BirdSearch> {
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
