import 'package:beakpeek/Model/bird_map.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HeatMap extends StatefulWidget {
  const HeatMap({super.key, this.testController, required this.id});

  final GoogleMapController? testController;
  final int id;

  @override
  State<HeatMap> createState() => HeatMapState();
}

class HeatMapState extends State<HeatMap> {
  late GoogleMapController mapController;
  final LatLng _defaultCenter = const LatLng(-25.7559141, 28.2330593);
  late CameraPosition _cameraPosition;
  final Set<Polygon> _polygons = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cameraPosition = CameraPosition(
      target: _defaultCenter,
      zoom: 11.0,
    );
    loadPentadData(); // Use this instead of KML loading
  }

  Color getColorForReportingRate(double reportingRate) {
    if (reportingRate < 20) {
      return const Color.fromARGB(255, 255, 115, 105).withOpacity(0.8);
    } else if (reportingRate < 40) {
      return Colors.red.withOpacity(0.8);
    } else if (reportingRate < 60) {
      return Colors.orange.withOpacity(0.8);
    } else if (reportingRate < 80) {
      return Colors.yellow.withOpacity(0.8);
    } else if (reportingRate < 90) {
      return const Color.fromARGB(255, 103, 255, 108).withOpacity(0.8);
    } else {
      return const Color.fromARGB(255, 1, 201, 34).withOpacity(0.8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: _cameraPosition,
            polygons: _polygons,
          ),
        ),
      ],
    );
  }

  CameraPosition getCameraPositionForProvince(String province) {
    switch (province) {
      case 'gauteng':
        return const CameraPosition(
            target: LatLng(-25.7559141, 28.2330593), zoom: 8.0);
      case 'westerncape':
        return const CameraPosition(
            target: LatLng(-33.9249, 18.4241), zoom: 8.0);
      case 'Eastern Cape':
        return const CameraPosition(
            target: LatLng(-32.2968, 26.4194), zoom: 8.0);
      default:
        return const CameraPosition(
            target: LatLng(-25.7559141, 28.2330593), zoom: 8.0);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = widget.testController ?? controller;
  }

  LatLng _calculateCoordinatesFromPentad(String lonPart, String latPart) {
    final latDegrees = int.parse(latPart.substring(0, 2));
    final latMinutes = int.parse(latPart.substring(2, 4));

    final lonDegrees = int.parse(lonPart.substring(0, 2));
    final lonMinutes = int.parse(lonPart.substring(2, 4));

    // Convert to decimal degrees
    final latitude = -(latDegrees + (latMinutes / 60.0));
    final longitude = lonDegrees + (lonMinutes / 60.0);

    return LatLng(latitude, longitude);
  }

  Future<void> loadPentadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final birdData =
          await BirdMapFunctions().fetchBirdsByGroupAndSpecies(widget.id);

      // Process data and create polygons in chunks
      final List<Polygon> polygons = [];
      for (var bird in birdData) {
        final id = bird.pentadAllocation;
        if (id != '') {
          final coordinates = [
            _calculateCoordinatesFromPentad(bird.pentadLatitude.toString(),
                bird.pentadLongitude.toString()),
            _calculateCoordinatesFromPentad(
                (bird.pentadLatitude + 5).toString(),
                bird.pentadLongitude.toString()),
            _calculateCoordinatesFromPentad(
                (bird.pentadLatitude + 5).toString(),
                (bird.pentadLongitude + 5).toString()),
            _calculateCoordinatesFromPentad(bird.pentadLatitude.toString(),
                (bird.pentadLongitude + 5).toString()),
            // Simplified example, you may need to adjust this
          ];

          final color = getColorForReportingRate(bird.reportingRate);
          polygons.add(
            Polygon(
              polygonId: PolygonId(id),
              points: coordinates,
              strokeColor: Colors.black38,
              fillColor: color,
              strokeWidth: 1,
              consumeTapEvents: true,
            ),
          );
        }

        // // Update the UI in chunks
        if (polygons.length % 100 == 0) {
          setState(() {
            _polygons.addAll(polygons);
          });
        }
      }

      setState(() {
        _polygons.addAll(polygons);
        _isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading Pentad data: $e');
      }
      setState(() {
        _isLoading = false;
      });
    }
  }
}
