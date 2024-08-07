import 'package:beakpeek/Controller/DB/achievements_provider.dart';
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
  late AchievementsProvider achievementList = AchievementsProvider.instance;
  late Future<List<Bird>> birds;
  late Future<List<int>> numBirds;

  String name = localStorage.getItem('fullName') ?? '';
  String bio = localStorage.getItem('bio') ?? 'Tell us about yourself...';
  String email = localStorage.getItem('email') ?? 'example@mail.com';
  String phone = localStorage.getItem('phone') ?? '+123456789';

  //level variables
  String levelStore = localStorage.getItem('level') ?? '0';
  String userProgress = localStorage.getItem('userExp') ?? '0';
  late int level;
  late int userExp;
  late int levelProgress;

  late List<int> numberOfBirdsPerProvince;
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
    birds = lifeList.fetchLifeList();
    numBirds = db.getNumberOfBirdsInProvinces(Client());
    level = int.parse(levelStore);
    userExp = int.parse(userProgress);
    levelProgress = getLevelExp();
    countProv().then(
      (count) {
        setState(
          () {
            numberOfBirdsPerProvince = count;
          },
        );
      },
    );
    super.initState();
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
                        // Profile picture
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

                        // Username
                        Text(name, style: GlobalStyles.subHeadingDark),

                        // Active since
                        const SizedBox(height: 6),
                        const Text('Active since - June 2024',
                            style: GlobalStyles.smallContent),
                        const SizedBox(height: 6),
                      ],
                    ),
                  ),

                  // Level indicator
                  Column(
                    children: [
                      Text(
                        'Level $level',
                        style: GlobalStyles.greyContent,
                      ),
                      SizedBox(
                        height: 30,
                        child: levelProgressBar(userExp, level),
                      ),
                    ],
                  ),

                  // Personal information
                  const SizedBox(height: 10),
                  const Text('Personal Information',
                      style: GlobalStyles.subheadingLight),
                  const SizedBox(height: 10),

                  // Bio Field with Subheading
                  ProfileField(
                    icon: Icons.info,
                    label: 'Bio',
                    content: bio,
                  ),

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
                    icon: Icons.email,
                    label: 'Email',
                    content: email,
                  ),

                  const SizedBox(height: 10),
                  const SizedBox(height: 10),

                  // Achievements section
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
                      return progressBars(
                          snapshot.data!, numberOfBirdsPerProvince);
                    },
                  ),
                  //
                  // Padding to prevent overlap with the bottom fixed container
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // Container for button at the bottom
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
