// ignore_for_file: unused_field

import 'package:beakpeek/Model/BirdInfo/bird_pentad.dart';
import 'package:beakpeek/Model/Globals/globals.dart';
import 'package:beakpeek/Model/bird_map.dart';
import 'package:beakpeek/Styles/colors.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:beakpeek/Model/bird_page_functions.dart';
import 'package:beakpeek/View/UserProfile/color_palette.dart';
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
  late List<dynamic> birdData = [];
  bool _isLoading = true;
  String _selectedMonth = 'Year-Round';
  int population = 0;

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
      return global.palette.low.withOpacity(0.8);
    } else if (reportingRate < 40) {
      return global.palette.mediumLow.withOpacity(0.8);
    } else if (reportingRate < 60) {
      return global.palette.medium.withOpacity(0.8);
    } else if (reportingRate < 80) {
      return global.palette.mediumHigh.withOpacity(0.8);
    } else if (reportingRate < 90) {
      return global.palette.high.withOpacity(0.8);
    } else {
      return global.palette.veryHigh.withOpacity(0.8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            if (population > 0) ...[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'This is an Endangered Species! Est. Population: $population',
                  style: GlobalStyles.contentPrimary(context).copyWith(
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor(context),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.left, // Align the text to the right
                  overflow: TextOverflow.ellipsis, // Prevent overflow
                ),
              ),
            ] else if (population < 0) ...[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'This is not an Endangered Species!',
                  style: GlobalStyles.contentPrimary(context).copyWith(
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor(context),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.left, // Align the text to the right
                  overflow: TextOverflow.ellipsis, // Prevent overflow
                ),
              ),
            ] else ...[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'This is an Endangered Species!',
                  style: GlobalStyles.contentPrimary(context).copyWith(
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor(context),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.left, // Align the text to the right
                  overflow: TextOverflow.ellipsis, // Prevent overflow
                ),
              ),
            ],
            Expanded(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: _cameraPosition,
                polygons: _polygons,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFiltersRow(),
              _buildLegend(context),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildFiltersRow() {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.filter_alt,
                color: AppColors.primaryColorLight),
            onPressed: () {
              _showFilterDialog();
            },
          ),
          GestureDetector(
            onTap: () {
              _showFilterDialog();
            },
            child: Text('Filter Map',
                style: GlobalStyles.contentPrimary(context).copyWith(
                    fontSize: 16, color: AppColors.primaryColorLight)),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PaletteSelector(),
            ),
          ).then((_) {
            _polygons.clear(); // Clear the polygons
            loadPentadData(); // Load the pentad data
          });
        },
        child: Container(
          height: 230,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(10), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Legend title
              Text(
                'Legend',
                style: GlobalStyles.contentPrimary(context)
                    .copyWith(fontSize: 16, color: AppColors.primaryColorLight),
              ),
              const SizedBox(height: 8), // Space between title and items
              // Create legend items
              _buildLegendItem(global.palette.low, '0-19%'),
              _buildLegendItem(global.palette.mediumLow, '20-39%'),
              _buildLegendItem(global.palette.medium, '40-59%'),
              _buildLegendItem(global.palette.mediumHigh, '60-79%'),
              _buildLegendItem(global.palette.high, '80-89%'),
              _buildLegendItem(global.palette.veryHigh, '90-100%'),
            ],
          ),
        ));
  }

// Helper method to create individual legend items
  Widget _buildLegendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 4.0), // Vertical padding for each item
      child: Row(
        mainAxisSize: MainAxisSize.min, // Set to min to avoid stretching
        children: [
          Container(
            width: 30, // Smaller width for the color box
            height: 15, // Smaller height for the color box
            color: color,
          ),
          const SizedBox(width: 8),
          Flexible(
            // Use Flexible instead of Expanded
            child: Text(
              label,
              style: GlobalStyles.contentPrimary(context)
                  .copyWith(fontSize: 14, color: AppColors.primaryColorLight),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Map Filters',
              style: GlobalStyles.smallHeadingPrimary(context),
            ),
          ),
          backgroundColor: AppColors.backgroundColor(context),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 20.0,
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
                      _polygons.clear();
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
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  style: GlobalStyles.contentPrimary(context),
                  dropdownColor: AppColors.popupColor(context),
                  iconEnabledColor: AppColors.secondaryColor(context),
                ),
              ]),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _polygons.clear();
                });

                loadPentadData();

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
      _polygons.clear();
    });

    try {
      if (birdData.isEmpty) {
        birdData =
            await BirdMapFunctions().fetchBirdsByGroupAndSpecies(widget.id);
      }
      population =
          ApiService().populationHelper(birdData[0].bird, birdData.length);
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
          ];

          final color = getColorForReportingRate(
              getReportingRateForMonth(bird, _selectedMonth));
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

        if (polygons.length % 100 == 0 && mounted) {
          setState(() {
            _polygons.addAll(polygons);
          });
        }
      }

      if (mounted) {
        setState(() {
          _polygons.addAll(polygons);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading Pentad data: $e');
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

double getReportingRateForMonth(BirdPentad bird, String month) {
  switch (month) {
    case 'January':
      return bird.jan;
    case 'February':
      return bird.feb;
    case 'March':
      return bird.mar;
    case 'April':
      return bird.apr;
    case 'May':
      return bird.may;
    case 'June':
      return bird.jun;
    case 'July':
      return bird.jul;
    case 'August':
      return bird.aug;
    case 'September':
      return bird.sep;
    case 'October':
      return bird.oct;
    case 'November':
      return bird.nov;
    case 'December':
      return bird.dec;
    case 'Year-Round':
    default:
      return bird.reportingRate;
  }
}
