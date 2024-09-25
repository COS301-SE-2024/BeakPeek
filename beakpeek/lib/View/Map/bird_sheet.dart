// ignore: lines_longer_than_80_chars
// ignore_for_file: avoid_print, library_private_types_in_public_api, sized_box_for_whitespace

import 'dart:convert';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Model/Globals/globals.dart';
import 'package:beakpeek/Styles/colors.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:beakpeek/View/Bird/bird_page.dart';
// ignore: unused_import
import 'package:beakpeek/View/Map/heat_map.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class BirdSheet extends StatefulWidget {
  const BirdSheet({super.key, required this.pentadId, required this.month});
  final String pentadId;
  final String month;

  @override
  _BirdSheetState createState() => _BirdSheetState();
}

class _BirdSheetState extends State<BirdSheet> {
  double _heightFactor = 0.5; // Initial height factor
  double rate = 0.0;
  String _selectedSortOption = 'Sort';
  String _selectedFilterOption = 'All';
  late Future<List<Bird>> _birdList;

  @override
  void initState() {
    super.initState();
    _birdList = fetchBirds(widget.pentadId,
        http.Client()); // Fetch and sort birds from the API initially
  }

  void _refreshBirdList() {
    _birdList = fetchBirds(widget.pentadId, http.Client()).then((birds) {
      // Sort the list of birds based on the selected sort option
      print(birds[0]);
      return _sortBirds(birds, _selectedSortOption);
    }).catchError((error) {
      // Handle error fetching birds
      print('Error fetching birds: $error');
      throw Exception('Failed to load birds: $error');
    });
  }

  List<Bird> _sortBirds(List<Bird> birds, String sortOption) {
    // Sorting logic based on the selected sort option
    switch (sortOption) {
      case 'Rarity Asc':
        birds.sort((a, b) => getReportingRateForMonth(a, widget.month)
            .compareTo(getReportingRateForMonth(b, widget.month)));
        break;
      case 'Rarity Desc':
        birds.sort((a, b) => getReportingRateForMonth(b, widget.month)
            .compareTo(getReportingRateForMonth(a, widget.month)));
        break;
      case 'Alphabetically Asc':
        birds.sort((a, b) => a.commonGroup.compareTo(b.commonGroup));
        break;
      case 'Alphabetically Desc':
        birds.sort((a, b) => b.commonGroup.compareTo(a.commonGroup));
        break;
      default:
        birds.sort((a, b) => a.commonGroup.compareTo(b.commonGroup));
        break;
    }
    return birds;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        setState(() {
          _heightFactor -=
              details.primaryDelta! / MediaQuery.of(context).size.height;
          _heightFactor = _heightFactor.clamp(0.2, 0.9);
        });
      },
      child: FractionallySizedBox(
        alignment: Alignment.bottomCenter,
        heightFactor: _heightFactor,
        child: Material(
          color: AppColors.backgroundColor(
              context), // Set the background color for better visibility
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: screenHeight * 0.03,
                child: Center(
                  child: Container(
                    height: screenHeight * 0.005,
                    width: screenWidth * 0.12,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(screenHeight * 0.002),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.01,
                ),
                child: Text(
                  'Birds in This Area',
                  style: GlobalStyles.smallHeadingPrimary(context),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Sort Dropdown
                  Flexible(
                    child: Container(
                      width: screenWidth * 0.4, // Make the dropdown narrower
                      child: DropdownButton<String>(
                        isExpanded:
                            true, // Ensures the dropdown items fit inside
                        value: _selectedSortOption,
                        items: <String>[
                          'Sort',
                          'Rarity Asc',
                          'Rarity Desc',
                          'Alphabetically Asc',
                          'Alphabetically Desc'
                        ].map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: GlobalStyles.contentSecondary(context),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedSortOption = newValue!;
                            _refreshBirdList();
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                      width: screenWidth *
                          0.05), // Space between the two dropdowns

                  // Filter Dropdown
                  Flexible(
                    child: Container(
                      width: screenWidth * 0.4, // Make the dropdown narrower
                      child: DropdownButton<String>(
                        isExpanded:
                            true, // Ensures the dropdown items fit inside
                        value: _selectedFilterOption,
                        items: <String>[
                          'Birds You\'ve Seen',
                          'Birds You Haven\'t Seen',
                          'All'
                        ].map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: GlobalStyles.contentSecondary(context),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedFilterOption = newValue!;
                            _refreshBirdList();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: FutureBuilder<List<Bird>>(
                  future: _birdList,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('No birds found.'));
                    }
                    return BirdList(birds: snapshot.data!, month: widget.month);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<List<Bird>> fetchBirds(String pentadId, http.Client client) async {
  try {
    // print(pentadId);
    final response = await client.get(Uri.parse(
        'https://beakpeekbirdapi.azurewebsites.net/api/Bird/$pentadId/pentad'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Bird.fromJson(data)).toList();
    } else {
      print('Request failed with status: ${response.statusCode}');
      throw Exception('Failed to load birds');
    }
  } catch (error) {
    print('Error fetching birds: $error');
    throw Exception(error);
  }
}

class BirdList extends StatelessWidget {
  const BirdList({super.key, required this.birds, required this.month});
  final List<Bird> birds;
  final String month;

  @override
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView.builder(
        itemCount: birds.length,
        itemBuilder: (context, index) {
          final bird = birds[index];
          final reportingRate = getReportingRateForMonth(bird, month);

          // Return an empty widget if the reporting rate is 0.0
          if (reportingRate == 0.0) {
            return const SizedBox.shrink();
          }

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    body: BirdPage(
                      id: bird.id,
                      commonGroup: bird.commonGroup,
                      commonSpecies: bird.commonSpecies,
                    ),
                  ),
                ),
              );
            },
            child: ListTile(
              tileColor: index % 2 == 0
                  ? AppColors.backgroundColor(context)
                  : AppColors.popupColor(context), // Alternate row color
              title: Text(
                bird.commonGroup != 'None'
                    ? '${bird.commonSpecies} ${bird.commonGroup}'
                    : bird.commonSpecies,
                style: TextStyle(
                  color: AppColors.primaryColor(context),
                ),
              ),
              subtitle: Text(
                'Scientific Name: ${bird.genus} ${bird.species}',
                style: TextStyle(
                  color: AppColors.secondaryColor(context),
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${reportingRate.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: AppColors.secondaryColor(context),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getColorForReportingRate(reportingRate),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getColorForReportingRate(double reportingRate) {
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
}

double getReportingRateForMonth(Bird bird, String month) {
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
