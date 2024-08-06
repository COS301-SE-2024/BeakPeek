class Bird {
  Bird({
    required this.pentad,
    required this.spp,
    required this.commonGroup,
    required this.commonSpecies,
    required this.genus,
    required this.species,
    required this.reportingRate,
  });

  factory Bird.fromJson(Map<String, dynamic> json) {
    return Bird(
      pentad: json['pentad'] ?? '',
      spp: json['spp'] ?? 0,
      commonGroup: json['common_group'],
      commonSpecies: json['common_species'],
      genus: json['genus'] ?? '',
      species: json['species'] ?? '',
      reportingRate: json['reportingRate'] != null ? json['reportingRate'].toDouble() : 0.0,

    );
  }

  final String pentad;
  final int spp;
  final String commonGroup;
  final String commonSpecies;
  final String genus;
  final String species;
  final double reportingRate;

  Map<String, Object?> toMap() {
    return {
      'pentad': pentad,
      'spp': spp,
      'commonGroup': commonGroup,
      'commonSpecies': commonSpecies,
      'genus': genus,
      'species': species,
      'reportingRate': reportingRate,
    };
  }

  @override
  String toString() {
    return '''Bird{spp: $spp, commonGroup: $commonGroup, commonSpecies: $commonSpecies}''';
  }
}
