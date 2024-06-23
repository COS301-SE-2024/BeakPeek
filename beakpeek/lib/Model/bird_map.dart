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
  Future<List<Bird>> fetchBirdsByGroupAndSpecies(
      String commonGroup, String commonSpecies) async {
    final Uri uri = Uri.http('10.0.2.2:5000', '/api/Bird/search',
        {'commonGroup': commonGroup, 'commonSpecies': commonSpecies});

    try {
      final response = await http.get(uri);

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
