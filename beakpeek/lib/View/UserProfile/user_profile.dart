import 'package:beakpeek/Model/user_profile_function.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:beakpeek/Styles/profile_page_styles.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({required this.change, super.key});
  const UserProfile.changeTheme(this.change, {super.key});
  final Function() change;

  @override
  State<UserProfile> createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  Widget iconDisplay = getIcon();
  String iconLabel = getLabelIcon();
  String name = localStorage.getItem('fullName') ?? '';
  String bio = localStorage.getItem('bio') ?? 'Tell us about yourself...';
  String email = localStorage.getItem('email') ?? 'example@mail.com';

  @override
  void initState() {
    if (name.isEmpty) {
      name = 'Elm Boog';
    }
    if (bio.isEmpty) {
      bio = 'Tell us about yourself...';
    }
    if (email.isEmpty) {
      email = 'example@mail.com';
    }
    iconDisplay = getIcon();
    iconLabel = getLabelIcon();
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
                  const SizedBox(height: 40),

                  // Profile image and name in center
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 78,
                          backgroundColor: ProfilePageStyles.primaryColor,
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
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),

                  const Divider(height: 1, thickness: 1),

                  // Name Field with Subheading
                  const SizedBox(height: 20),
                  const Text('Full Name', style: ProfilePageStyles.subheading),
                  const SizedBox(height: 8),
                  Text(name, style: ProfilePageStyles.content),

                  // Bio Field with Subheading
                  const SizedBox(height: 20),
                  const Text('Bio', style: ProfilePageStyles.subheading),
                  const SizedBox(height: 8),
                  Text(bio, style: ProfilePageStyles.content),

                  // Email Field with Subheading
                  const SizedBox(height: 20),
                  const Text('Email', style: ProfilePageStyles.subheading),
                  const SizedBox(height: 8),
                  Text(email, style: ProfilePageStyles.content),

                  // Subheading for Life List
                  const SizedBox(height: 20),
                  const Divider(height: 1, thickness: 1),
                  const SizedBox(height: 20),
                  const Text('Your Life List',
                      style: ProfilePageStyles.heading),
                  const SizedBox(height: 10),

                  // Live List
                  getLiveList(),

                  // Divider between the list and buttons
                  const SizedBox(height: 20),
                  const Divider(height: 1, thickness: 1),

                  // Buttons at the bottom
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Home button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/home');
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
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? ProfilePageStyles.iconColorDarkMode
                                  : ProfilePageStyles.iconColorLightMode,
                            ),
                            const SizedBox(width: 2),
                            Switch(
                              value: Theme.of(context).brightness ==
                                  Brightness.dark,
                              onChanged: (value) {
                                widget.change();
                                setState(() {
                                  iconDisplay = getIcon();
                                  iconLabel = getLabelIcon();
                                });
                              },
                              activeColor: ProfilePageStyles.primaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Positioned icons (pencil and settings)
          Positioned(
            top: 16,
            right: 16,
            child: Row(
              children: [
                IconButton(
                  iconSize: 36,
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Action for edit profile icon
                  },
                ),
                IconButton(
                  iconSize: 36,
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
