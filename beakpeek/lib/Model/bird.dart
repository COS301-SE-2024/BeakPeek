class Bird {
  Bird({
    required this.id,
    required this.pentad,
    required this.commonGroup,
    required this.commonSpecies,
    required this.genus,
    required this.species,
    required this.fullProtocolRR,
    required this.fullProtocolNumber,
    required this.latestFP,
    required this.jan,
    required this.feb,
    required this.mar,
    required this.apr,
    required this.may,
    required this.jun,
    required this.jul,
    required this.aug,
    required this.sep,
    required this.oct,
    required this.nov,
    required this.dec,
    required this.totalRecords,
    required this.reportingRate,
  });

  factory Bird.fromJson(Map<String, dynamic> json) {
    return Bird(
      id: json['bird']['ref'],
      pentad: Pentad.fromJson(json['pentad']),
      commonGroup: json['bird']['common_group']??'None',
      commonSpecies: json['bird']['common_species'],
      genus: json['bird']['genus'],
      species: json['bird']['species'],
      fullProtocolRR: json['bird']['full_Protocol_RR'] ?? 0.0,
      fullProtocolNumber: json['bird']['full_Protocol_Number'] ?? 0,
      latestFP: json['bird']['latest_FP'] ?? '',
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
      totalRecords: json['total_Records'] ?? 0,
      reportingRate: json['reportingRate']?.toDouble() ?? 0.0,
    );
  }

  final int id;
  final Pentad pentad;
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

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'pentad': pentad.toMap(),
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

  @override
  String toString() {
    return 'Bird{id: $id, commonGroup: $commonGroup, commonSpecies: $commonSpecies, reportingRate: $reportingRate}';
  }
}

class Pentad {
  Pentad({
    required this.pentadAllocation,
    required this.pentadLongitude,
    required this.pentadLatitude,
    required this.province,
    required this.totalCards,
  });

  factory Pentad.fromJson(Map<String, dynamic> json) {
    return Pentad(
      pentadAllocation: json['pentad_Allocation'],
      pentadLongitude: json['pentad_Longitude']?.toDouble() ?? 0.0,
      pentadLatitude: json['pentad_Latitude']?.toDouble() ?? 0.0,
      province: Province.fromJson(json['province']),
      totalCards: json['total_Cards'],
    );
  }

  final String pentadAllocation;
  final double pentadLongitude;
  final double pentadLatitude;
  final Province province;
  final int totalCards;

  Map<String, Object?> toMap() {
    return {
      'pentadAllocation': pentadAllocation,
      'pentadLongitude': pentadLongitude,
      'pentadLatitude': pentadLatitude,
      'province': province.toMap(),
      'totalCards': totalCards,
    };
  }
}

class Province {
  Province({
    required this.id,
    required this.name,
    this.birds,
  });

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      id: json['id'],
      name: json['name'],
      birds: json['birds'],
    );
  }

  final int id;
  final String name;
  final dynamic birds;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'birds': birds,
    };
  }
}

class BirdPentad {
  final String pentadAllocation;
  final double reportingRate;

  BirdPentad({required this.pentadAllocation, required this.reportingRate});

  factory BirdPentad.fromJson(Map<String, dynamic> json) {
    return BirdPentad(
      pentadAllocation: json['pentad']['pentad_Allocation'] ?? '',
      reportingRate: json['reportingRate']?.toDouble() ?? 0.0,
    );
  }
}
