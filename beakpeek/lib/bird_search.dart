// ignore_for_file: avoid_print, lines_longer_than_80_chars

import 'dart:convert';
import 'package:beakpeek/bird.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

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
    birds = fetchBirds(); // Fetch and sort birds from the API initially
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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

  Future<List<Bird>> fetchBirds() async {
    try {
      // print(pentadId);
      final response = await http
          .get(Uri.parse('http://10.0.2.2:5000/api/GautengBirdSpecies'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Bird.fromJson(data)).toList();
      } else {
        print('Request failed with status: ${response.statusCode}');
        throw Exception('Failed to load birds');
      }
    } catch (error) {
      print('Error fetching birds: $error');
      throw Exception('Failed to load birds: $error');
    }
  }
}

class BirdList extends StatelessWidget {
  const BirdList({super.key, required this.birds});
  final List<Bird> birds;

  @override
  Widget build(BuildContext context) {
    return ListFilter(
      birds: birds,
    );
  }

  // ignore: unused_element
  Color _getColorForReportingRate(double reportingRate) {
    if (reportingRate < 40) {
      return Colors.red;
    } else if (reportingRate < 60) {
      return Colors.orange;
    } else if (reportingRate < 80) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }
}

class ListFilter extends StatefulWidget {
  // ignore: use_super_parameters
  const ListFilter({Key? key, required this.birds}) : super(key: key);

  //const ListFilter({super.key, required this.birds});
  final List<Bird> birds;

  @override
  State<ListFilter> createState() => FilterState();
}

class FilterState extends State<ListFilter> {
  late final List<Bird> birds;
  late TextEditingController _controller;
  late List<Bird> outputList;

  @override
  void initState() {
    super.initState();
    birds = widget.birds;
    outputList = widget.birds;
    _controller = TextEditingController();
  }

  void filter(String value) {
    setState(() {
      outputList =
          birds.where((bird) => bird.commonSpecies.startsWith(value)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          onChanged: (value) {
            filter(value);
          },
          decoration: const InputDecoration(
            labelText: 'Search',
          ),
        ),
        OverflowBox(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: outputList.length,
            itemBuilder: (context, index) {
              final bird = outputList[index];
              return ListTile(
                title: Text(
                    '${bird.commonSpecies} (${bird.genus} ${bird.species})'),
                subtitle: Text('Group: ${bird.commonGroup}'),
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
                        color: _getColorForReportingRate(bird.reportingRate),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getColorForReportingRate(double reportingRate) {
    if (reportingRate < 40) {
      return Colors.red;
    } else if (reportingRate < 60) {
      return Colors.orange;
    } else if (reportingRate < 80) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }
}
