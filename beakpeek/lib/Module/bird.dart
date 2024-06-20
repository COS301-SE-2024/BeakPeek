// ignore_for_file: avoid_print

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
      pentad: json['pentad'],
      spp: json['spp'],
      commonGroup: json['common_group'],
      commonSpecies: json['common_species'],
      genus: json['genus'],
      species: json['species'],
      reportingRate: json['reportingRate'].toDouble(),
    );
  }

  final String pentad;
  final int spp;
  final String commonGroup;
  final String commonSpecies;
  final String genus;
  final String species;
  final double reportingRate;
}
