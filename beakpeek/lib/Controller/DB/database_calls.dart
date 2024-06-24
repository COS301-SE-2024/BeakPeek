// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:beakpeek/Model/bird.dart';
import 'package:beakpeek/Model/bird_search_functions.dart';
import 'package:http/http.dart' as http;

Future<List<Bird>> fetchAllBirds(http.Client client) async {
  try {
    final response = await client.get(
        Uri.parse('http://10.0.2.2:5000/api/Bird/GetBirdsInProvince/gauteng'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      final List<Bird> birds =
          jsonResponse.map((data) => Bird.fromJson(data)).toList();
      return getUniqueBirds(birds);
    } else {
      print('Request failed with status: ${response.statusCode}');
      throw Exception('Failed to load birds');
    }
  } catch (error) {
    print('Error fetching birds: $error');
    throw Exception('Failed to load birds: $error, ');
  }
}
