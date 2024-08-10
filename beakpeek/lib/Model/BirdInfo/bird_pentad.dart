class BirdPentad {
  BirdPentad({required this.pentadAllocation, required this.reportingRate});

  factory BirdPentad.fromJson(Map<String, dynamic> json) {
    // print(json['reportingRate']);
    return BirdPentad(
      pentadAllocation: json?['pentad']?['pentad_Allocation'] ?? '',
      reportingRate: json?['reportingRate'] ?? 0.0,
    );
  }
  final String pentadAllocation;
  final double reportingRate;
}
