// ignore_for_file: avoid_print, unused_element
import 'dart:convert';
import 'package:beakpeek/Module/bird.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BirdSearchFunctions {
  Future<List<Bird>> fetchAllBirds(http.Client client) async {
    try {
      final response = await client
          .get(Uri.parse('http://10.0.2.2:5000/api/GautengBirdSpecies'));
      print(response);
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Bird.fromJson(data)).toList();
      } else {
        print('Request failed with status: ${response.statusCode}');
        throw Exception('Failed to load birds');
      }
    } catch (error) {
      final response = await client
          .get(Uri.parse('http://10.0.2.2:5000/api/GautengBirdSpecies'));
      final List<dynamic> jsonResponse = json.decode(response.body);
      print(response.body);
      print('Error fetching birds: $error');
      throw Exception(
          'Failed to load birds: $error, the response is $jsonResponse');
    }
  }

  final colorArray = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
  ];

  int getColorForReportingRate(double reportingRate) {
    if (reportingRate < 40) {
      return 0;
    } else if (reportingRate < 60) {
      return 1;
    } else if (reportingRate < 80) {
      return 2;
    } else {
      return 3;
    }
  }
}
