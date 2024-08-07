// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:beakpeek/Model/bird.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class KmlParser {
  static List<Map<String, dynamic>> parseKml(String kmlString) {
    final document = XmlDocument.parse(kmlString);
    final List<Map<String, dynamic>> polygonsData = [];

    for (var placemark in document.findAllElements('Placemark')) {
      final idElement = placemark.findElements('name').firstOrNull;
      final coordinatesElements = placemark.findAllElements('coordinates');
      // print(coordinatesElements);
      if (idElement != null && coordinatesElements.isNotEmpty) {
        final pentadId = idElement.text.trim();

        final List<Map<String, double>> polygonCoordinates = [];
        for (var coordinatesElement in coordinatesElements) {
          final coordinateText = coordinatesElement.text.trim();
          final coordinateParts = coordinateText.split(' ');

          for (var part in coordinateParts) {
            final latLng = part.split(',');
            if (latLng.length >= 2) {
              final latitude = double.tryParse(latLng[1]);
              final longitude = double.tryParse(latLng[0]);
              if (latitude != null && longitude != null) {
                polygonCoordinates.add({
                  'latitude': latitude,
                  'longitude': longitude,
                });
              }
            }
          }
        }

        polygonsData.add({
          'id': pentadId,
          'coordinates': polygonCoordinates,
        });
      }
    }

    return polygonsData;
  }
}

class BirdMapFunctions {
  Future<List<dynamic>> fetchBirdsByGroupAndSpecies(int id) async {
    final Uri uri = Uri.http(
      '10.0.2.2:5000',
      '/api/Bird/getBirdPentads/$id'
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Decode the JSON response
        final List<dynamic> data = json.decode(response.body);

        // Map the data to a list of BirdPentad objects
        final List<BirdPentad> birdPentads = data.map((item) {
          return BirdPentad.fromJson(item);
        }).toList();

        return birdPentads;
      } else {
        print('Failed to load data: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }
}
