// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';

class BirdSearch extends StatefulWidget {
  const BirdSearch({super.key});

  @override
  State<BirdSearch> createState() => _BirdSearchState();
}

class _BirdSearchState extends State<BirdSearch> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text(
        'hello',
      ),
    );
  }

  Future<List<Bird>> fetchBirds() async {
    try {
      // print(pentadId);
      final response = await http
          .get(Uri.parse('http://10.0.2.2:5000/api/GautengBirdSpecies'));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
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
