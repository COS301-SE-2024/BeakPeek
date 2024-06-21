// ignore_for_file: avoid_print, unused_element
import 'dart:convert';
import 'package:beakpeek/Model/bird.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Bird>> fetchAllBirds(http.Client client) async {
  try {
    final response = await client
        .get(Uri.parse('http://10.0.2.2:5000/api/GautengBirdSpecies'));
    print(response);
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

Widget getData(Bird bird) {
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
            color: colorArray[getColorForReportingRate(bird.reportingRate)],
          ),
        ),
      ],
    ),
  );
}

List<Widget> getWidgetListOfBirds(List<Bird> birds) {
  final List<Widget> listOfBirdWidgets = [];

  for (var i = 0; i < birds.length; i++) {
    listOfBirdWidgets.add(getData(birds[i]));
  }
  return listOfBirdWidgets;
}

List<Bird> sortAlphabetically(List<Bird> birds) {
  birds.sort((a, b) => a.commonGroup.compareTo(b.commonGroup));
  return birds;
}

List<Bird> sortRepotRateDESC(List<Bird> birds) {
  birds.sort((a, b) => b.reportingRate.compareTo(a.reportingRate));
  return birds;
}

List<Bird> searchForBird(List<Bird> birds, String value) {
  final List<Bird> results = birds
      .where((bird) =>
          (bird.commonSpecies).toLowerCase().contains(value.toLowerCase()) ||
          (bird.commonGroup).toLowerCase().contains(value.toLowerCase()))
      .toList();
  return results;
}

List<Bird> getUniqueBirds(List<Bird> birds) {
  final Set<String> uniqueBirdKeys = {};
  final List<Bird> uniqueBirds = [];

  for (var bird in birds) {
    final birdKey = '${bird.commonGroup}-${bird.commonSpecies}';
    if (!uniqueBirdKeys.contains(birdKey)) {
      uniqueBirdKeys.add(birdKey);
      uniqueBirds.add(bird);
    }
  }

  return uniqueBirds;
}
