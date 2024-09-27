// ignore: lines_longer_than_80_chars
// ignore_for_file: avoid_redundant_argument_values, empty_catches, unused_element, avoid_print

import 'package:beakpeek/Model/bird_map.dart';
import 'package:beakpeek/Styles/colors.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:beakpeek/View/Map/bird_sheet.dart';
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
  LatLng _currentLocation =
      const LatLng(-25.7559141, 28.2330593); // Default location
  String _selectedProvince = 'Gauteng'; // Capitalized default province
  String _selectedMonth = 'Year-Round'; // Default selected month
  late CameraPosition _cameraPosition;
  Set<Polygon> _polygons = {};
  bool _isLocationFetched = false;

  final Map<String, LatLng> provinceCenters = {
    'Gauteng': const LatLng(-25.7559141, 28.2330593),
    'Western Cape': const LatLng(-33.9249, 18.4241),
    'Eastern Cape': const LatLng(-32.2968, 26.4194),
    'KwaZulu-Natal': const LatLng(-29.8587, 31.0218),
    'Limpopo': const LatLng(-23.8962, 29.4486),
    'Mpumalanga': const LatLng(-25.5653, 30.5276),
    'Free State': const LatLng(-29.0852, 26.1596),
    'Northern Cape': const LatLng(-28.7281, 24.7499),
    'North West': const LatLng(-25.6696, 25.9323),
  };

  @override
  void initState() {
    super.initState();
    _cameraPosition = CameraPosition(target: _currentLocation, zoom: 11.0);
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
      final Position position = await Geolocator.getCurrentPosition();
      final latitude = position.latitude;
      final longitude = position.longitude;

      // Check if the location is within South Africa's boundaries
      if (!(latitude < -35.0 ||
          latitude > -22.0 ||
          longitude < 16.0 ||
          longitude > 33.0)) {
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
          mapController
              .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
        }
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFiltersRow(),
        Expanded(
          child: GoogleMap(
            onMapCreated: (controller) {
              mapController = controller;
              if (_isLocationFetched) {
                mapController.animateCamera(
                    CameraUpdate.newCameraPosition(_cameraPosition));
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

  Widget _buildFiltersRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          width: 12.0,
        ),
        IconButton(
          icon: Icon(Icons.filter_alt, color: AppColors.greyColor(context)),
          onPressed: () {
            _showFilterDialog();
          },
        ),
        GestureDetector(
          onTap: () {
            _showFilterDialog();
          },
          child: Text('Filter map', style: GlobalStyles.smallContent(context)),
        ),
      ],
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text('Map Filters',
                style: GlobalStyles.smallHeadingPrimary(context)),
          ),
          backgroundColor: AppColors.backgroundColor(context),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Province Dropdown
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 20.0,
                      color: AppColors.iconColor(context),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Filter by province:',
                      style: GlobalStyles.contentPrimary(context)
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4.0),
              DropdownButtonFormField<String>(
                value: _selectedProvince,
                onChanged: (newValue) {
                  setState(() {
                    _polygons = {};
                    _selectedProvince = newValue!;
                    _cameraPosition = CameraPosition(
                        target: provinceCenters[newValue]!, zoom: 11.0);
                    _loadKmlData();
                  });

                  // Move the camera to the new position
                  mapController.animateCamera(
                      CameraUpdate.newCameraPosition(_cameraPosition));
                },
                items:
                    provinceCenters.keys.map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: GlobalStyles.contentPrimary(context)
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  fillColor: AppColors.popupColor(context),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                style: GlobalStyles.contentPrimary(context),
                dropdownColor: AppColors.popupColor(context),
                iconEnabledColor: AppColors.secondaryColor(context),
              ),
              const SizedBox(height: 10.0),

              // Month Dropdown
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 18.0,
                      color: AppColors.iconColor(context),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Filter by month:',
                      style: GlobalStyles.contentPrimary(context)
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4.0),
              DropdownButtonFormField<String>(
                value: _selectedMonth,
                onChanged: (newValue) {
                  setState(() {
                    _selectedMonth = newValue!;
                  });
                },
                items: <String>[
                  'Year-Round',
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
                      style: GlobalStyles.contentPrimary(context)
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  fillColor: AppColors.popupColor(context),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                style: GlobalStyles.contentPrimary(context),
                dropdownColor: AppColors.popupColor(context),
                iconEnabledColor: AppColors.secondaryColor(context),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: GlobalStyles.smallContentPrimary(context),
              ),
            ),
          ],
        );
      },
    );
  }

  CameraPosition _getCameraPositionForProvince(String province) {
    return CameraPosition(target: provinceCenters[province]!, zoom: 11.0);
  }

  Future<void> _loadKmlData() async {
    try {
      // print(_selectedProvince);
      final kmlString = await rootBundle.loadString(
          'assets/province_${_selectedProvince.toLowerCase().replaceAll(" ", "")}.kml');
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
            strokeColor: Colors.grey.withOpacity(0.1),
            fillColor: Colors.transparent,
            strokeWidth: 2,
            consumeTapEvents: true,
            onTap: () {
              _onPolygonTapped(id);
            },
          );
        }).toSet();
      });
    } catch (e) {}
  }

  void _onPolygonTapped(String id) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BirdSheet(pentadId: id, month: _selectedMonth);
      },
    );
  }
}
