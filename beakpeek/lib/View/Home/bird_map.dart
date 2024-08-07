import 'package:beakpeek/Model/bird_map.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:beakpeek/View/Home/bird_sheet.dart';
import 'package:flutter/foundation.dart';
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
  String _selectedMonth = 'January'; // Default selected month
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
        _buildFiltersRow(),
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

  Widget _buildFiltersRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon:
              const Icon(Icons.filter_list, color: GlobalStyles.secondaryColor),
          onPressed: () {
            _showFilterDialog();
          },
        ),
      ],
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filters'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Province Dropdown
              DropdownButtonFormField<String>(
                value: _selectedProvince,
                onChanged: (newValue) {
                  setState(() {
                    _selectedProvince = newValue!;
                    _cameraPosition = _getCameraPositionForProvince(newValue);
                    _loadKmlData();
                  });

                  // Move the camera to the new position
                  mapController.animateCamera(
                      CameraUpdate.newCameraPosition(_cameraPosition));
                },
                items: <String>['gauteng', 'westerncape', 'Eastern Cape']
                    .map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: GlobalStyles.secondaryColor, width: 2.0),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: GlobalStyles.secondaryColor, width: 2.0),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                style: const TextStyle(color: Colors.black, fontSize: 14.0),
                dropdownColor: Colors.white,
                iconEnabledColor: GlobalStyles.secondaryColor,
              ),
              const SizedBox(height: 10.0),

              // Month Dropdown
              DropdownButtonFormField<String>(
                value: _selectedMonth,
                onChanged: (newValue) {
                  setState(() {
                    _selectedMonth = newValue!;
                  });
                },
                items: <String>[
                  'January',
                  'February',
                  'March',
                  'April',
                  'May',
                  'June',
                  'July',
                  'August',
                  'September',
                  'October',
                  'November',
                  'December'
                ].map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: GlobalStyles.secondaryColor, width: 2.0),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: GlobalStyles.secondaryColor, width: 2.0),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                style: const TextStyle(color: Colors.black, fontSize: 14.0),
                dropdownColor: Colors.white,
                iconEnabledColor: GlobalStyles.secondaryColor,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  CameraPosition _getCameraPositionForProvince(String province) {
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
