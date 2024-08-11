class BirdPentad {
  BirdPentad(
      {required this.pentadAllocation,
      required this.reportingRate,
      required this.pentadLongitude,
      required this.pentadLatitude});

  factory BirdPentad.fromJson(Map<String, dynamic> json) {
    return BirdPentad(
        pentadAllocation: json['pentad']?['pentad_Allocation'] ?? '',
        reportingRate: json['reportingRate'] ?? 0.0,
        pentadLatitude: json['pentad']?['pentad_Latitude'] ?? 0,
        pentadLongitude: json['pentad']?['pentad_Longitude'] ?? 0);
  }
  final String pentadAllocation;
  final double reportingRate;
  final int pentadLatitude;
  final int pentadLongitude;
}
