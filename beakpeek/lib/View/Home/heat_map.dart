import 'package:beakpeek/Model/bird.dart';
import 'package:beakpeek/Model/bird_map.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class HeatMap extends StatefulWidget {
  const HeatMap({super.key, this.testController, required this.commonGroup, required this.commonSpecies});

  final GoogleMapController? testController;
  final String commonGroup;
  final String commonSpecies;

  @override
  State<HeatMap> createState() => HeatMapState();
}

class HeatMapState extends State<HeatMap> {
  late GoogleMapController mapController;
  final LatLng _defaultCenter = const LatLng(-25.7559141, 28.2330593);
  String _selectedProvince = 'gauteng'; // Default selected province
  late CameraPosition _cameraPosition;
  Set<Polygon> _polygons = {};

  @override
  void initState() {
    super.initState();
    _cameraPosition = CameraPosition(
      target: _defaultCenter,
      zoom: 11.0,
    );
    _loadKmlData();
  }


  Color _getColorForReportingRate(double reportingRate) {
    if (reportingRate < 40) {
      return Colors.red.withOpacity(0.4);
    } else if (reportingRate < 60) {
      return Colors.orange.withOpacity(0.4);
    } else if (reportingRate < 80) {
      return Colors.yellow.withOpacity(0.4);
    } else {
      return Colors.green.withOpacity(0.4);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildProvinceDropdown(),
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

  Widget _buildProvinceDropdown() {
    return DropdownButton<String>(
      value: _selectedProvince,
      onChanged: (newValue) {
        setState(() {
          _selectedProvince = newValue!;
          _cameraPosition = _getCameraPositionForProvince(newValue);
          _loadKmlData();
        });

        // Move the camera to the new position
        mapController.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
      },
      items: <String>[
        'gauteng',
        'westerncape',
        'Eastern Cape'
      ] // Add more provinces as needed
          .map<DropdownMenuItem<String>>((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  CameraPosition _getCameraPositionForProvince(String province) {
    // Set camera positions for different provinces
    switch (province) {
      case 'gauteng':
        return const CameraPosition(
            target: LatLng(-25.7559141, 28.2330593));
      case 'westerncape':
        return const CameraPosition(
            target: LatLng(-33.9249, 18.4241), zoom: 2.0);
      case 'Eastern Cape':
        return const CameraPosition(
            target: LatLng(-32.2968, 26.4194), zoom: 2.0);
      default:
        return const CameraPosition(
            target: LatLng(-25.7559141, 28.2330593));
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = widget.testController ?? controller;
  }

  Future<void> _loadKmlData() async {
    try {
      final kmlString = await rootBundle.loadString('assets/province_$_selectedProvince.kml');
      final polygonsData = KmlParser.parseKml(kmlString);
      final birdData = await BirdMapFunctions().fetchBirdsByGroupAndSpecies(widget.commonGroup, widget.commonSpecies);
      setState(() {
        _polygons = polygonsData.map((polygonData) {
          final id = polygonData['id'];
          final coordinates = (polygonData['coordinates'] as List<Map<String, double>>)
              .map((coord) => LatLng(coord['latitude']!, coord['longitude']!))
              .toList();
          final bird = birdData.firstWhere(
            (b) => b.pentad == id,
            orElse: () => Bird(pentad: '', reportingRate: 0.0, spp: 0, commonGroup: '', commonSpecies: '', genus: '', species: ''),
          );
          final color = _getColorForReportingRate(bird.reportingRate);
          return Polygon(
            polygonId: PolygonId(id),
            points: coordinates,
            strokeColor: Colors.transparent,
            fillColor: color,
            strokeWidth: 2,
            consumeTapEvents: true,
          );
        }).toSet();
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading KML data: $e');
      }
    }
  }
}


