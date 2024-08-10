import 'package:beakpeek/Model/BirdInfo/province.dart';

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
