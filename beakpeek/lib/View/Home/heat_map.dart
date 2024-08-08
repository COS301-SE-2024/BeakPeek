import 'package:beakpeek/Model/bird.dart';
import 'package:beakpeek/Model/bird_map.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

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
    loadKmlData();
  }

  Color getColorForReportingRate(double reportingRate) {
    print(reportingRate);
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
          _cameraPosition = getCameraPositionForProvince(newValue);
          loadKmlData();
        });

        // Move the camera to the new position
        mapController
            .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
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

  CameraPosition getCameraPositionForProvince(String province) {
    // Set camera positions for different provinces
    switch (province) {
      case 'gauteng':
        return const CameraPosition(target: LatLng(-25.7559141, 28.2330593));
      case 'westerncape':
        return const CameraPosition(
            target: LatLng(-33.9249, 18.4241), zoom: 2.0);
      case 'Eastern Cape':
        return const CameraPosition(
            target: LatLng(-32.2968, 26.4194), zoom: 2.0);
      default:
        return const CameraPosition(target: LatLng(-25.7559141, 28.2330593));
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = widget.testController ?? controller;
  }

  Future<void> loadKmlData() async {
    try {
      final kmlString =
          await rootBundle.loadString('assets/province_$_selectedProvince.kml');
      final polygonsData = KmlParser.parseKml(kmlString);
      final birdData =
          await BirdMapFunctions().fetchBirdsByGroupAndSpecies(widget.id);
      print(birdData);
      setState(() {
        _polygons = polygonsData.map((polygonData) {
          final id = polygonData['id'];
          final coordinates = (polygonData['coordinates']
                  as List<Map<String, double>>)
              .map((coord) => LatLng(coord['latitude']!, coord['longitude']!))
              .toList();
          final bird = birdData.firstWhere(
            (b) => b.pentad.pentadAllocation == id,
            orElse: () => BirdPentad(pentadAllocation: '', reportingRate: 60.0),
          );
          final color = getColorForReportingRate(bird.reportingRate);
          return Polygon(
            polygonId: PolygonId(id),
            points: coordinates,
            strokeColor: Colors.black38,
            fillColor: color,
            strokeWidth: 1,
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
