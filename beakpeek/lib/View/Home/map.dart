<<<<<<<< HEAD:beakpeek/lib/View/Home/bird_map.dart
// bird_map.dart

import 'package:beakpeek/Model/bird_map.dart';
import 'package:beakpeek/View/Home/bird_sheet.dart';
import 'package:flutter/foundation.dart';
========
// ignore_for_file: avoid_print, lines_longer_than_80_chars, avoid_types_on_closure_parameters, always_declare_return_types, type_annotate_public_apis
import 'package:beakpeek/View/Home/bird.dart';
>>>>>>>> 00bf3e6 (file moving/ renaming):beakpeek/lib/View/Home/map.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class BirdMap extends StatefulWidget {
  const BirdMap({super.key, this.testController});

  final GoogleMapController? testController;

  @override
  State<BirdMap> createState() => BirdMapState();
}

class BirdMapState extends State<BirdMap> {
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
      final kmlString =
          await rootBundle.loadString('assets/province_$_selectedProvince.kml');
      final polygonsData = KmlParser.parseKml(kmlString);

      setState(() {
        _polygons = polygonsData.map((polygonData) {
          final id = polygonData['id'];
          final coordinates = (polygonData['coordinates']
                  as List<Map<String, double>>)
              .map((coord) => LatLng(coord['latitude']!, coord['longitude']!))
              .toList();
          return Polygon(
            polygonId: PolygonId(id),
            points: coordinates,
            strokeColor: Colors.transparent,
            fillColor: Colors.transparent,
            strokeWidth: 2,
            consumeTapEvents: true,
            onTap: () {
              _onPolygonTapped(id);
            },
          );
        }).toSet();
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading KML data: $e');
      }
    }
  }

  void _onPolygonTapped(String id) {
    if (kDebugMode) {
      print('Polygon with ID: $id tapped');
    }
    // Show the draggable bottom sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BirdSheet(pentadId: id);
      },
    );
  }

}
