import 'package:beakpeek/Model/bird_map.dart';
import 'package:beakpeek/View/Home/bird_sheet.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';

class BirdMap extends StatefulWidget {
  const BirdMap({super.key, this.testController});

  final GoogleMapController? testController;

  @override
  State<BirdMap> createState() => BirdMapState();
}

class BirdMapState extends State<BirdMap> {
  late GoogleMapController mapController;
  LatLng _currentLocation = const LatLng(-25.7559141, 28.2330593); // Default location
  String _selectedProvince = 'gauteng'; // Default selected province
  late CameraPosition _cameraPosition;
  Set<Polygon> _polygons = {};
  bool _isLocationFetched = false;

  @override
  void initState() {
    super.initState();
    _cameraPosition = CameraPosition(
      target: _currentLocation,
      zoom: 11.0,
    );
    _getCurrentLocation();
    _loadKmlData();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    // Fetch current location
    try {
      Position position = await Geolocator.getCurrentPosition();

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _cameraPosition = CameraPosition(
          target: _currentLocation,
          zoom: 11.0,
        );
        _isLocationFetched = true;
      });

      // Update map camera if mapController is initialized
      if (_isLocationFetched) {
        mapController.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildProvinceDropdown(),
        Expanded(
          child: GoogleMap(
            onMapCreated: (controller) {
              mapController = controller;
              if (_isLocationFetched) {
                mapController.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
              }
            },
            initialCameraPosition: _cameraPosition,
            polygons: _polygons,
            myLocationEnabled: true, // Enable the blue dot marker
            myLocationButtonEnabled: true, // Enable the "My Location" button
          ),
        ),
      ],
    );
  }

  Widget buildProvinceDropdown() {
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
            target: LatLng(-25.7559141, 28.2330593), zoom: 11.0);
      case 'westerncape':
        return const CameraPosition(
            target: LatLng(-33.9249, 18.4241), zoom: 11.0);
      case 'Eastern Cape':
        return const CameraPosition(
            target: LatLng(-32.2968, 26.4194), zoom: 11.0);
      default:
        return const CameraPosition(
            target: LatLng(-25.7559141, 28.2330593), zoom: 11.0);
    }
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
    }
  }

  void _onPolygonTapped(String id) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BirdSheet(pentadId: id);
      },
    );
  }
}
