import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:beakpeek/Model/bird.dart';
import 'package:beakpeek/Model/user_profile_function.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:beakpeek/Styles/profile_page_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:localstorage/localstorage.dart';
import 'package:beakpeek/Controller/DB/database_calls.dart' as db;

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  late LifeListProvider lifeList = LifeListProvider.instance;
  late Future<List<Bird>> birds;
  Widget iconDisplay = getIcon(localStorage);
  String iconLabel = getLabelIcon(localStorage);
  String name = localStorage.getItem('fullName') ?? '';
  late Future<List<int>> numBirds;
  String bio = localStorage.getItem('bio') ?? 'Tell us about yourself...';
  String email = localStorage.getItem('email') ?? 'example@mail.com';

  // Added variables
  String phone = localStorage.getItem('phone') ?? '+123456789';
  String website = localStorage.getItem('website') ?? 'https://example.com';
  String location = localStorage.getItem('location') ?? 'Unknown Location';

  @override
  void initState() {
    super.initState();
    if (name.isEmpty) {
      name = 'Elm Boog';
    }
    if (bio.isEmpty) {
      bio = 'Tell us about yourself...';
    }
    if (email.isEmpty) {
      email = 'example@mail.com';
    }
    iconDisplay = getIcon(localStorage);
    iconLabel = getLabelIcon(localStorage);
    birds = lifeList.fetchLifeList();
    numBirds = db.getNumberOfBirdsInProvinces(Client());
    super.initState();
  }

  void editName(String data) {
    localStorage.setItem('fullName', data);
    setState(() {
      name = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 75,
                          backgroundColor: GlobalStyles.primaryColor,
                          child: CircleAvatar(
                            radius: 75,
                            backgroundImage: const AssetImage(
                              'assets/images/profileImages/images.jpg',
                            ),
                            onBackgroundImageError: (_, __) => const Icon(
                              Icons.person,
                              size: 75,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        // Divider between the list and buttons
                        const Divider(height: 1, thickness: 1),
                        // Username
                        Text(name, style: GlobalStyles.subHeadingDark),

                        // Active since
                        const Text('Active since - June 2024',
                            style: GlobalStyles.smallContent),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),

                  const Divider(height: 1, thickness: 1),

                  const SizedBox(height: 10),
                  const Text('Personal Information',
                      style: GlobalStyles.subheadingLight),
                  const SizedBox(height: 20),

                  const SizedBox(height: 10),

                  // Phone Field
                  ProfileField(
                    icon: Icons.phone,
                    label: 'Phone',
                    content: phone,
                  ),

                  const SizedBox(height: 10),

                  // Location Field
                  ProfileField(
                    icon: Icons.location_on,
                    label: 'Location',
                    content: location,
                  ),

                  const SizedBox(height: 10),

                  // Bio Field with Subheading
                  ProfileField(
                    icon: Icons.info,
                    label: 'Bio',
                    content: bio,
                  ),

                  // Subheading for Life List
                  const SizedBox(height: 20),
                  const Divider(height: 1, thickness: 1),
                  const SizedBox(height: 20),
                  const Text('Life List', style: GlobalStyles.subheadingLight),
                  FutureBuilder<List<Bird>>(
                    future: birds,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      return getLiveList(snapshot.data!);
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Achievements',
                    style: GlobalStyles.subheadingLight,
                  ),
                  FutureBuilder<List<int>>(
                    future: numBirds,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }
                      return progressBars(snapshot.data!);
                    },
                  ),

                  // Padding to prevent overlap with the bottom fixed container
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          // Container for buttons at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              color: Colors.white, // White background for the container
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Home button
                  ElevatedButton(
                    onPressed: () {
                      context.go('/home');
                    },
                    style: ProfilePageStyles.elevatedButtonStyle(),
                    child: const Text('Home'),
                  ),

                  // Dark mode switch
                  Row(
                    children: [
                      Icon(
                        Theme.of(context).brightness == Brightness.dark
                            ? Icons.wb_sunny
                            : Icons.nightlight_round,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? ProfilePageStyles.iconColorDarkMode
                            : ProfilePageStyles.iconColorLightMode,
                      ),
                      const SizedBox(width: 2),
                      Switch(
                        value: Theme.of(context).brightness == Brightness.dark,
                        onChanged: (value) {
                          setState(() {
                            iconDisplay = getIcon(localStorage);
                            iconLabel = getLabelIcon(localStorage);
                          });
                        },
                        activeColor: GlobalStyles.primaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Fields for user personal information
class ProfileField extends StatelessWidget {
  const ProfileField({
    required this.icon,
    required this.label,
    required this.content,
    this.backgroundColor,
    this.padding,
    super.key,
  });

  final IconData icon;
  final String label;
  final String content;
  final Color? backgroundColor;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color.fromARGB(83, 204, 204, 204),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: GlobalStyles.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(label, style: GlobalStyles.smallContent),
            ],
          ),
          Expanded(
            child: Text(
              content,
              style: GlobalStyles.content,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
