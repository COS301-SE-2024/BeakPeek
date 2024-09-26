// ignore_for_file: unnecessary_null_comparison
import 'dart:convert';
import 'dart:io';
import 'package:beakpeek/Model/nav.dart';
import 'package:beakpeek/View/UserProfile/user_profile_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Model/UserProfile/user_profile_function.dart';
import 'package:beakpeek/Styles/colors.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// ignore: unused_import
import 'package:localstorage/localstorage.dart';
import 'package:beakpeek/config_azure.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  late LifeListProvider lifeList = LifeListProvider.instance;
  ImageProvider profilePicture =
      Image.memory(base64Decode(user.profilepicture)).image;
  late Future<List<Bird>> birds;
  late Future<List<int>> numBirds;
  late File _image = File('assets/images/profileImages/images.jpg');
  final picker = ImagePicker();

  String name = user.username;
  String username = user.username;
  String bio = user.description;

  // Level variables
  late int level;
  late int userExp;
  late int levelProgress;

  late List<int> numberOfBirdsPerProvince;

  @override
  void initState() {
    super.initState();
    birds = lifeList.fetchLifeList();
    level = user.level;
    userExp = user.xp;
    levelProgress = getLevelExp();
    countProv().then(
      (count) {
        setState(() {
          numberOfBirdsPerProvince = count;
        });
      },
    );
    retrieveLostData();
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
                            icon: const Icon(Icons.settings),
                            color: AppColors.iconColor(context),
                            onPressed: () {
                              context.go('/settings');
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
                        Material(
                          elevation: 5, // Add elevation here
                          shape: const CircleBorder(),
                          child: CircleAvatar(
                            radius: screenWidth * 0.20,
                            backgroundColor: AppColors.iconColor(context),
                            child: CircleAvatar(
                              radius: screenWidth * 0.19,
                              backgroundImage: _image.path.isEmpty
                                  ? const AssetImage(
                                      'assets/images/profileImages/images.jpg')
                                  : FileImage(_image),
                              foregroundImage: profilePicture,
                            ),
                          ),
                        ),
                        // Username
                        SizedBox(height: verticalPadding),
                        Text(
                          username,
                          style: GlobalStyles.subHeadingPrimary(context),
                        ),

                        // Active since
                        SizedBox(height: verticalPadding),
                        Text(
                          'Active since - June 2024',
                          style: GlobalStyles.smallContent(context),
                        ),
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
                        width: screenWidth,
                        child: Center(
                          child: levelProgressBar(),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.01),

                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 1,
                  ),

                  // Personal Information Section
                  SizedBox(height: verticalPadding),
                  Text(
                    'Personal Information',
                    style: GlobalStyles.smallHeadingSecondary(context),
                  ),
                  SizedBox(height: verticalPadding),

                  // Display static personal info with icons
                  _buildProfileField(
                    icon: Icons.person,
                    label: 'Username',
                    content: username,
                    context: context,
                  ),
                  SizedBox(height: verticalPadding),
                  _buildProfileField(
                    icon: Icons.info,
                    label: 'Bio',
                    content: bio,
                    context: context,
                  ),
                  SizedBox(height: verticalPadding),

                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }

  // Static profile field builder
  Widget _buildProfileField({
    required IconData icon,
    required String label,
    required String content,
    required BuildContext context,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fieldPadding = EdgeInsets.all(screenWidth * 0.03);

    return Material(
      elevation: 5, // Add elevation here
      borderRadius: BorderRadius.circular(screenWidth * 0.05),
      child: Container(
        padding: fieldPadding,
        decoration: BoxDecoration(
          color: AppColors.popupColor(context),
          borderRadius: BorderRadius.circular(screenWidth * 0.05),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.iconColor(context),
            ),
            SizedBox(width: screenWidth * 0.05),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GlobalStyles.smallHeadingPrimary(context),
                ),
                Text(
                  content,
                  style: GlobalStyles.smallContent(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.files != null) {
          _image = response.file as File;
        }
      });
    }
  }
}
