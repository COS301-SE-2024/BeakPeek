// api_service.dart

import 'dart:convert';
import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'beakpeekbirdapi.azurewebsites.net';
  // Replace with your actual API base URL

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

  Future<Map<String, Object?>> fetchBirdInfoOffline(
      LifeListProvider lifeList, int id) async {
    return await lifeList.getBirdInByID(id);
  }

  // void calculatePopulation(
  //     //error rate of about 30% but only upwards
  //     //(can only overestimate population)
  //     LifeListProvider lifeList) async {
  //   final List<Bird> birdHolder = await lifeList.getFullBirdData();

  //   for (Bird bird in birdHolder) {
  //     bird.population = populationHelper(bird);
  //   }
  // }

  int populationHelper(Bird bird, int pentads) {
    const double constant = 9.01;
    //Calculated using a neural network to
    //adjust function to fit known populations.

    const double detectionProbability = 0.3;
    //attempts to average for nocturnal birds etc.
    //considered: popularity of location, flightpaths of single bird
    //Day time bias, time period (maybe a lot of cards in one day creates unfair
    //outliers)
    //number obtained from literature
    //https://www.fs.usda.gov/psw/publications/documents/psw_gtr149/psw_gtr149_pg117_124.pdf
    //https://core.ac.uk/download/pdf/9821458.pdf

    //MULTIPLY HERE ->
    final double viewRate = bird.fullProtocolRR *
        bird.fullProtocolNumber *
        pentads /
        16673; // multiply by num pentads/16673
    final int population = (constant * viewRate / detectionProbability).round();
    print(population);
    if (population > 50000) {
      return -1;
    }
    return population;
  }
}
