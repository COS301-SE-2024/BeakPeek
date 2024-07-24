import 'package:beakpeek/Model/user_profile_function.dart';
import 'package:beakpeek/Styles/global_styles.dart';
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
    iconDisplay = getIcon();
    iconLabel = getLabelIcon();
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

                  // Profile image and name section
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
                        const SizedBox(height: 10),

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

                  // Email Field
                  ProfileField(
                    icon: Icons.email,
                    label: 'Email',
                    content: email,
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
                  const SizedBox(height: 10),

                  // Live List
                  getLiveList(),

                  // Padding to prevent overlap with the bottom fixed container
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // Positioned icons (pencil and settings)
          Positioned(
            top: 32,
            right: 16,
            child: Row(
              children: [
                IconButton(
                  iconSize: 28,
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Action for edit profile icon
                  },
                ),
                IconButton(
                  iconSize: 28,
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
              ],
            ),
          ),

          Positioned(
            top: 32,
            left: 16,
            child: IconButton(
              iconSize: 28,
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
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
                        color: Theme.of(context).brightness == Brightness.dark
                            ? ProfilePageStyles.iconColorDarkMode
                            : ProfilePageStyles.iconColorLightMode,
                      ),
                      const SizedBox(width: 2),
                      Switch(
                        value: Theme.of(context).brightness == Brightness.dark,
                        onChanged: (value) {
                          widget.change();
                          setState(() {
                            iconDisplay = getIcon();
                            iconLabel = getLabelIcon();
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
