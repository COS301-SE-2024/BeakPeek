import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:beakpeek/Model/bird.dart';
import 'package:beakpeek/Controller/DB/database_calls.dart' as db;
import 'package:beakpeek/View/Home/Searching/filterable_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class SearchbarContainer extends StatefulWidget {
  const SearchbarContainer({super.key});

  @override
  State<SearchbarContainer> createState() => _SearchbarContainerState();
}

class _SearchbarContainerState extends State<SearchbarContainer> {
  late LifeListProvider lifeList = LifeListProvider.instance;
  late Future<List<Bird>> birds;
  int sort = 0;

  @override
  void initState() {
    super.initState();
    birds = db.fetchAllBirds(Client());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row containing logo and search bar
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Image.asset(
                'assets/icons/Logo.png',
                width: 80, // Adjust size as needed
                height: 80,
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(214, 3, 58, 48),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for birds...',
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.search,
                          color: Color.fromARGB(214, 3, 58, 48), // Green color
                        ),
                      ),
                    ),
                  ),
                  // Loading indicator
                  Positioned(
                    right: 10,
                    top: 10,
                    bottom: 10,
                    child: FutureBuilder<List<Bird>>(
                      future: birds,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                            width: 30, // Adjust width
                            child: CircularProgressIndicator(
                              color: Color(0xFF033A30), // Green color
                              strokeWidth: 2.0,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return const SizedBox.shrink();
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // The FutureBuilder for handling API state
        FutureBuilder<List<Bird>>(
          future: birds,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox.shrink(); // Hide when loading
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
