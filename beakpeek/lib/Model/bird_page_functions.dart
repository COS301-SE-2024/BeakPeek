// api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      '10.0.2.2:5000'; // Replace with your actual API base URL

  Future<Map<String, dynamic>?> fetchBirdInfo(
      String commonGroup, String commonSpecies) async {
    final response = await http.get(
      Uri.http(baseUrl, 'api/BirdInfo/$commonSpecies $commonGroup'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      // Handle the error
      // ignore: avoid_print
      print('Failed to load bird info');
      return null;
    }
  }
}
