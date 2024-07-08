import 'package:beakpeek/Model/user_profile_function.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:slider_button/slider_button.dart';

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
      email = 'elmboog@gmail.com';
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
                        backgroundColor: const Color(0xFF033A30),
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

                      // Name Field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Bio Field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            bio,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Email Field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            email,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Subheading
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'Your Life List',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Live List
                      getLiveList(),

                      // Divider between the list and buttons
                      const Divider(height: 1, thickness: 1),

                      // Buttons at the bottom
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 40.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Home button
                            FilledButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/home');
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF033A30),
                                minimumSize: const Size(200, 50),
                                shadowColor: Colors.black,
                              ),
                              child: const Text(
                                'Home',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'SF Pro Display',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ),

                            // Dark mode slider
                            Transform.scale(
                              scale: 0.8,
                              child: SliderButton(
                                icon: Center(
                                  child: iconDisplay,
                                ),
                                action: () async {
                                  widget.change();
                                  setState(() {
                                    iconDisplay = getIcon();
                                    iconLabel = getLabelIcon();
                                  });
                                  return false;
                                },
                                width: 120,
                                height: 60,
                                boxShadow: BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Positioned settings icon
          Positioned(
              top: 16,
              right: 16,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  IconButton(
                    iconSize: 30,
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Action for edit profile
                    },
                  ),
                  IconButton(
                    iconSize: 30,
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
