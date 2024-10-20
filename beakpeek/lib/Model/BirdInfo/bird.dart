// ignore_for_file: avoid_redundant_argument_values

import 'package:beakpeek/Model/BirdInfo/pentad.dart';

class Bird {
  factory Bird.fromJson(Map<String, dynamic> json) {
    final birdJson = json['bird'] ?? json;
    return Bird(
      id: birdJson['ref'] as int, // default value for id
      pentad: birdJson['pentad'] != null
          ? Pentad.fromJson(birdJson['pentad'])
          : null,
      commonGroup: birdJson['common_group'] ?? 'None',
      commonSpecies: birdJson['common_species'] ?? '',
      genus: birdJson['genus'] ?? '',
      species: birdJson['species'] ?? '',
      fullProtocolRR: birdJson['full_Protocol_RR']?.toDouble() ?? 0.0,
      fullProtocolNumber: birdJson['full_Protocol_Number'] ?? 0,
      latestFP: birdJson['latest_FP'] ?? '',
      jan: json['jan']?.toDouble() ?? 0.0,
      feb: json['feb']?.toDouble() ?? 0.0,
      mar: json['mar']?.toDouble() ?? 0.0,
      apr: json['apr']?.toDouble() ?? 0.0,
      may: json['may']?.toDouble() ?? 0.0,
      jun: json['jun']?.toDouble() ?? 0.0,
      jul: json['jul']?.toDouble() ?? 0.0,
      aug: json['aug']?.toDouble() ?? 0.0,
      sep: json['sep']?.toDouble() ?? 0.0,
      oct: json['oct']?.toDouble() ?? 0.0,
      nov: json['nov']?.toDouble() ?? 0.0,
      dec: json['dec']?.toDouble() ?? 0.0,
      totalRecords: birdJson['total_Records'] ?? json['total_Records'] ?? 0,
      reportingRate: birdJson['reportingRate']?.toDouble() ??
          json['reportingRate']?.toDouble() ??
          0.0,
      info: json['info'] ?? '',
      imageUrl: birdJson['image_Url'] ?? '',
      provinces: List<String>.from(json['provinces'] ?? []),
      //population changes below
      population: 0,
    );
  }

  factory Bird.fromJsonLife(Map<String, dynamic> json) {
    final birdJson = json['bird'] ?? json;
    return Bird(
      id: birdJson['id'] as int, // default value for id
      pentad: birdJson['pentad'] != null
          ? Pentad.fromJson(birdJson['pentad'])
          : null,
      commonGroup: birdJson['common_group'] ?? 'None',
      commonSpecies: birdJson['common_species'] ?? '',
      genus: birdJson['genus'] ?? '',
      species: birdJson['species'] ?? '',
      fullProtocolRR: birdJson['full_Protocol_RR']?.toDouble() ?? 0.0,
      fullProtocolNumber: birdJson['full_Protocol_Number'] ?? 0,
      latestFP: birdJson['latest_FP'] ?? '',
      jan: json['jan']?.toDouble() ?? 0.0,
      feb: json['feb']?.toDouble() ?? 0.0,
      mar: json['mar']?.toDouble() ?? 0.0,
      apr: json['apr']?.toDouble() ?? 0.0,
      may: json['may']?.toDouble() ?? 0.0,
      jun: json['jun']?.toDouble() ?? 0.0,
      jul: json['jul']?.toDouble() ?? 0.0,
      aug: json['aug']?.toDouble() ?? 0.0,
      sep: json['sep']?.toDouble() ?? 0.0,
      oct: json['oct']?.toDouble() ?? 0.0,
      nov: json['nov']?.toDouble() ?? 0.0,
      dec: json['dec']?.toDouble() ?? 0.0,
      totalRecords: birdJson['total_Records'] ?? json['total_Records'] ?? 0,
      reportingRate: birdJson['reportingRate']?.toDouble() ??
          json['reportingRate']?.toDouble() ??
          0.0,
      info: json['info'] ?? '',
      imageUrl: birdJson['image_Url'] ?? '',
      provinces: List<String>.from(json['provinces'] ?? []),
      //population changes below
      population: 0,
    );
  }

  factory Bird.fromJsonLifeList(Map<String, dynamic> json) {
    final birdJson = json['bird'] ?? json;
    return Bird(
      id: birdJson['id'] as int, // default value for id
      commonGroup: birdJson['commonGroup'] ?? 'None',
      commonSpecies: birdJson['commonSpecies'] ?? '',
      genus: birdJson['genus'] ?? '',
      species: birdJson['species'] ?? '',
      fullProtocolRR: 0.0,
      fullProtocolNumber: 0,
      latestFP: '',
      jan: 0.0,
      feb: 0.0,
      mar: 0.0,
      apr: 0.0,
      may: 0.0,
      jun: 0.0,
      jul: 0.0,
      aug: 0.0,
      sep: 0.0,
      oct: 0.0,
      nov: 0.0,
      dec: 0.0,
      totalRecords: 0,
      imageUrl: birdJson['image_Url'] ?? '',
      // imageBlob: birdJson['image_Blob'] ? birdJson['image_Blob']asString:'',
      reportingRate: birdJson['reportingRate']?.toDouble() ??
          json['reportingRate']?.toDouble() ??
          0.0,
    );
  }

  Bird({
    required this.id,
    this.pentad,
    this.imageUrl,
    this.imageBlob,
    this.info,
    this.provinces,
    required this.commonGroup,
    required this.commonSpecies,
    required this.genus,
    required this.species,
    required this.fullProtocolRR,
    required this.fullProtocolNumber,
    required this.latestFP,
    this.jan = 0.0,
    this.feb = 0.0,
    this.mar = 0.0,
    this.apr = 0.0,
    this.may = 0.0,
    this.jun = 0.0,
    this.jul = 0.0,
    this.aug = 0.0,
    this.sep = 0.0,
    this.oct = 0.0,
    this.nov = 0.0,
    this.dec = 0.0,
    required this.totalRecords,
    required this.reportingRate,
    //maybe needs to come out
    this.population,
  });
  //population changes
  int? population;

  final int id;
  final Pentad? pentad;
  final String commonGroup;
  final String commonSpecies;
  final String genus;
  final String species;
  final double fullProtocolRR;
  final int fullProtocolNumber;
  final String latestFP;
  final double jan;
  final double feb;
  final double mar;
  final double apr;
  final double may;
  final double jun;
  final double jul;
  final double aug;
  final double sep;
  final double oct;
  final double nov;
  final double dec;
  final int totalRecords;
  final double reportingRate;
  final String? info;
  final String? imageUrl;
  final String? imageBlob;
  final List<String>? provinces;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'pentad': pentad?.toMap(),
      'commonGroup': commonGroup,
      'commonSpecies': commonSpecies,
      'genus': genus,
      'species': species,
      'fullProtocolRR': fullProtocolRR,
      'fullProtocolNumber': fullProtocolNumber,
      'latestFP': latestFP,
      'jan': jan,
      'feb': feb,
      'mar': mar,
      'apr': apr,
      'may': may,
      'jun': jun,
      'jul': jul,
      'aug': aug,
      'sep': sep,
      'oct': oct,
      'nov': nov,
      'dec': dec,
      'totalRecords': totalRecords,
      'reportingRate': reportingRate,
    };
  }

  Map<String, Object?> toMapLIfe() {
    return {
      'id': id,
      'commonGroup': commonGroup,
      'commonSpecies': commonSpecies,
      'genus': genus,
      'species': species,
      'reportingRate': reportingRate,
      'image_Url': imageUrl,
      'image_Blob': imageBlob
    };
  }

  Map<String, Object?> toMapProvince() {
    return {
      'id': id,
      'gauteng': provinces!.contains('gauteng') ? 1 : 0,
      'kwazulunatal': provinces!.contains('kwazulunatal') ? 1 : 0,
      'limpopo': provinces!.contains('limpopo') ? 1 : 0,
      'mpumalanga': provinces!.contains('mpumalanga') ? 1 : 0,
      'northerncape': provinces!.contains('northerncape') ? 1 : 0,
      'northwest': provinces!.contains('northwest') ? 1 : 0,
      'westerncape': provinces!.contains('westerncape') ? 1 : 0,
      'freestate': provinces!.contains('freestate') ? 1 : 0,
    };
  }

  Map<String, Object?> toAllBirdsMap() {
    return {
      'id': id,
      'commonGroup': commonGroup,
      'commonSpecies': commonSpecies,
      'genus': genus,
      'species': species,
      'fullProtocolRR': fullProtocolRR,
      'fullProtocolNumber': fullProtocolNumber,
      'latestFP': latestFP,
      'jan': jan,
      'feb': feb,
      'mar': mar,
      'apr': apr,
      'may': may,
      'jun': jun,
      'jul': jul,
      'aug': aug,
      'sep': sep,
      'oct': oct,
      'nov': nov,
      'dec': dec,
      'totalRecords': totalRecords,
      'reportingRate': reportingRate,
      'info': info,
      'image_Blob': '',
      'image_Url': imageUrl,
      'birdPopulation': 0
    };
  }

  int getId() {
    return id;
  }

  @override
  String toString() {
    return '''Bird id: $id, commonGroup: $commonGroup, 
    commonSpecies: $commonSpecies, reportingRate: $reportingRate''';
  }
}
