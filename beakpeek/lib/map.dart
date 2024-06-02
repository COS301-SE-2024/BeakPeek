import 'package:beakpeek/bird.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:xml/xml.dart' as xml;
import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart';
// import 'package:beakpeek/LandingText/nav.dart';


class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
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
            onTap: _onMapTap,
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
    items: <String>['gauteng', 'westerncape', 'Eastern Cape'] // Add more provinces as needed
        .map<DropdownMenuItem<String>>((String value) {
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
        return const CameraPosition(target: LatLng(-25.7559141, 28.2330593), zoom: 11.0);
      case 'westerncape':
        return const CameraPosition(target: LatLng(-33.9249, 18.4241), zoom: 10.0);
      case 'Eastern Cape':
        return const CameraPosition(target: LatLng(-32.2968, 26.4194), zoom: 8.0);
      default:
        return const CameraPosition(target: LatLng(-25.7559141, 28.2330593), zoom: 11.0);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _loadKmlData() async {
    try {
      final kmlString = await rootBundle.loadString('assets/province_$_selectedProvince.kml');
      final polygonsData = KmlParser.parseKml(kmlString);

      setState(() {
        _polygons = polygonsData.map((polygonData) {
          final id = polygonData['id'];
          final coordinates = (polygonData['coordinates'] as List<Map<String, double>>)
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
      print('Error loading KML data: $e');
    }
  }

void _onPolygonTapped(String id) {
  print('Polygon with ID: $id tapped');
  // Show the draggable bottom sheet
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Set to true to allow full screen dragging
    builder: (context) {
      return ResizableBottomSheet(pentadId: id); // Assuming DraggableBirdSheet is your bottom sheet widget
    },
  );
}


  void _onMapTap(LatLng latLng) {
    print('Map tapped at: $latLng');
    // Handle map tap event here
  }
}

class KmlParser {
  static List<Map<String, dynamic>> parseKml(String kmlString) {
    final document = XmlDocument.parse(kmlString);
    final List<Map<String, dynamic>> polygonsData = [];

    for (var placemark in document.findAllElements('Placemark')) {
      final idElement = placemark.findElements('name').firstOrNull;
      final coordinatesElements = placemark.findAllElements('coordinates');
      // print(coordinatesElements);
      if (idElement != null && coordinatesElements.isNotEmpty) {
        final pentadId = idElement.text.trim();

        List<Map<String, double>> polygonCoordinates = [];
        for (var coordinatesElement in coordinatesElements) {
          final coordinateText = coordinatesElement.text.trim();
          final coordinateParts = coordinateText.split(' ');

          for (var part in coordinateParts) {
            final latLng = part.split(',');
            if (latLng.length >= 2) {
              final latitude = double.tryParse(latLng[1]);
              final longitude = double.tryParse(latLng[0]);
              if (latitude != null && longitude != null) {
                polygonCoordinates.add({
                  'latitude': latitude,
                  'longitude': longitude,
                });
              }
            }
          }
        }

        polygonsData.add({
          'id': pentadId,
          'coordinates': polygonCoordinates,
        });
      }
    }

    return polygonsData;
  }

}