import 'package:beakpeek/Model/BirdInfo/bird.dart';

class BirdPentad {
  BirdPentad(
      {required this.pentadAllocation,
      required this.reportingRate,
      required this.pentadLongitude,
      required this.pentadLatitude,
      required this.bird,
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
      required this.totalPentadReports});

  factory BirdPentad.fromJson(Map<String, dynamic> json) {
    return BirdPentad(
      pentadAllocation: json['pentad']?['pentad_Allocation'] ?? '',
      reportingRate: json['reportingRate'] ?? 0.0,
      pentadLatitude: json['pentad']?['pentad_Latitude'] ?? 0,
      pentadLongitude: json['pentad']?['pentad_Longitude'] ?? 0,
      totalPentadReports: json['total_Records'] ?? 0,
      bird: Bird.fromJson(json['bird']),
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
    );
  }
  final String pentadAllocation;
  final double reportingRate;
  final int pentadLatitude;
  final int pentadLongitude;
  final int totalPentadReports;
  final Bird bird;
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

  @override
  String toString() {
    return 'Bird: $bird';
  }
}
