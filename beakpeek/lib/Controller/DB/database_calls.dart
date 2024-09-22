// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Model/BirdInfo/bird_search_functions.dart';
import 'package:http/http.dart' as http;

const List<String> provinces = [
  'easterncape',
  'gauteng',
  'kwazulunatal',
  'limpopo',
  'mpumalanga',
  'northerncape',
  'northwest',
  'westerncape',
  'freestate',
];

Future<List<Bird>> fetchAllBirds(String prov, http.Client client) async {
  try {
    final response = await client.get(Uri.parse(
        'https://beakpeekbirdapi.azurewebsites.net/api/Bird/GetBirdsInProvince/$prov'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      final List<Bird> birds =
          jsonResponse.map((data) => Bird.fromJson(data)).toList();
      return getUniqueBirds(birds);
    } else {
      //print('Request failed with status: ${response.statusCode}');
      throw Exception('Failed to load birds');
    }
  } catch (error) {
    //print('Error fetching birds: $error');
    throw Exception('Failed to load birds: $error, ');
  }
}

Future<List<int>> getNumberOfBirdsInProvinces(http.Client client) async {
  late final List<int> numbers = [];
  try {
    for (var i = 0; i < provinces.length; i++) {
      final String temp = provinces[i];
      final response = await client.get(Uri.parse(
          'https://beakpeekbirdapi.azurewebsites.net/api/Bird/GetNumBirdByProvince/$temp'));
      if (response.statusCode == 200) {
        final int jsonResponse = json.decode(response.body);
        numbers.add(jsonResponse);
      } else {
        print('Request failed with status: ${response.statusCode}');
        throw Exception('Failed to load amount of birds');
      }
    }
    return numbers;
  } catch (error) {
    //print('Error fetching amount of birds: $error');
    throw Exception('Failed to load number of birds: $error, ');
  }
}

Future<List> getProvincesBirdIsIn(
    http.Client client, String commonSpecies, String commonGroup) async {
  late final List isIn;
  try {
    final response = await client.get(
      Uri.parse(
          'https://beakpeekbirdapi.azurewebsites.net/api/Bird/GetBirdProvinces/$commonSpecies/$commonGroup'),
    );
    if (response.statusCode == 200) {
      final List jsonResponse = json.decode(response.body);
      //print(json.decode(response.body));
      isIn = jsonResponse;
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Failed to load provinces for $commonSpecies, $commonGroup');
      return [true, true, true, true, true, true, true, true, true];
    }
    return isIn;
  } catch (error) {
    print('Error fetching amount of birds: $error');
    throw Exception('Failed to load number of birds: $error, ');
  }
}

Future<List<bool>> getProvincesForBird(int id) async {
  late final LifeListProvider lifeList = LifeListProvider.instance;
  late final List<bool> isIn = [];
  await lifeList.getBirdProvinces(id).then((prov) {
    isIn.add((prov.easterncape));
    isIn.add((prov.gauteng));
    isIn.add((prov.kwazulunatal));
    isIn.add((prov.limpopo));
    isIn.add((prov.mpumalanga));
    isIn.add((prov.northerncape));
    isIn.add((prov.northwest));
    isIn.add((prov.westerncape));
    isIn.add((prov.freestate));
  });
  //print(isIn);
  return isIn;
}
