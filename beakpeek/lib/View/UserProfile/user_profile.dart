import 'package:beakpeek/Controller/DB/achievements_provider.dart';
import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Model/UserProfile/user_profile_function.dart';
import 'package:beakpeek/Styles/colors.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:localstorage/localstorage.dart';
import 'package:beakpeek/Controller/DB/database_calls.dart' as db;
import 'package:provider/provider.dart';
import 'package:beakpeek/Controller/Main/theme_provider.dart';

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
  String username = localStorage.getItem('username') ?? 'Username';
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final verticalPadding = screenHeight * 0.01;
    final horizontalPadding = screenWidth * 0.05;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor(context),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: verticalPadding * 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: AppColors.iconColor(context),
                        onPressed: () {
                          context.go('/home');
                        },
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Provider.of<ThemeProvider>(context).themeMode ==
                                      ThemeMode.dark
                                  ? Icons.wb_sunny_outlined
                                  : Icons.nights_stay_outlined,
                              color: AppColors.iconColor(context),
                            ),
                            onPressed: () {
                              final isDarkMode = Provider.of<ThemeProvider>(
                                          context,
                                          listen: false)
                                      .themeMode ==
                                  ThemeMode.dark;
                              Provider.of<ThemeProvider>(context, listen: false)
                                  .toggleTheme(!isDarkMode);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings),
                            color: AppColors.iconColor(context),
                            onPressed: () {
                              // Navigate to settings page
                              //or handle settings action
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Center(
                    child: Column(
                      children: [
                        // Profile picture
                        CircleAvatar(
                          radius: screenWidth * 0.20,
                          backgroundColor: AppColors.iconColor(context),
                          child: CircleAvatar(
                            radius: screenWidth * 0.19,
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
                        SizedBox(height: verticalPadding),
                        Text(name,
                            style: GlobalStyles.subHeadingPrimary(context)),

                        // Active since
                        SizedBox(height: verticalPadding),
                        Text('Active since - June 2024',
                            style: GlobalStyles.smallContent(context)),
                        SizedBox(height: verticalPadding),
                      ],
                    ),
                  ),

                  // Level indicator
                  Column(
                    children: [
                      Text(
                        'Level $level',
                        style: GlobalStyles.smallContent(context),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        height: verticalPadding * 3,
                        child: levelProgressBar(userExp, level),
                      ),
                    ],
                  ),

                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 1,
                  ),

                  // Personal information
                  SizedBox(height: verticalPadding),
                  Text('Personal Information',
                      style: GlobalStyles.smallHeadingSecondary(context)),
                  SizedBox(height: verticalPadding),

                  // Username Field
                  ProfileField(
                    icon: Icons.person,
                    label: 'Username',
                    content: username,
                    backgroundColor: AppColors.popupColor(context),
                  ),
                  SizedBox(height: verticalPadding),

                  // Bio Field with Subheading
                  ProfileField(
                    icon: Icons.info,
                    label: 'Bio',
                    content: bio,
                    backgroundColor: AppColors.popupColor(context),
                  ),
                  SizedBox(height: verticalPadding),

                  // Email Field
                  ProfileField(
                    icon: Icons.email,
                    label: 'Email',
                    content: email,
                    backgroundColor: AppColors.popupColor(context),
                  ),
                  SizedBox(height: verticalPadding),

                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 1,
                  ),

                  // Progress section
                  Text(
                    'Sighting Progress',
                    style: GlobalStyles.smallHeadingPrimary(context),
                  ),
                  FutureBuilder<List<int>>(
                    future: numBirds,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(
                          color: AppColors.primaryColor(context),
                        ));
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text('Error: ${snapshot.error}',
                                style: GlobalStyles.contentPrimary(context)));
                      }
                      return progressBars(
                          snapshot.data!, numberOfBirdsPerProvince);
                    },
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
    final screenWidth = MediaQuery.of(context).size.width;
    final fieldPadding = EdgeInsets.all(screenWidth * 0.03);

    return Container(
      padding: padding ?? fieldPadding,
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color.fromARGB(83, 204, 204, 204),
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.iconColor(context),
              ),
              SizedBox(width: screenWidth * 0.02),
              // Text(label, style: GlobalStyles.smallContent),
            ],
          ),
          Expanded(
            child: Text(
              content,
              style: GlobalStyles.contentPrimary(context),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
