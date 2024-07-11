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
  @override
  void initState() {
    if (name.isEmpty) {
      name = 'Elm Boog';
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextField(
                          onChanged: (value) => editName(value),
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            hintText: 'Elm Boog',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(12.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF033A30)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextField(
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Bio',
                            hintText: 'Tell us about yourself...',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(12.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF033A30)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'example@mail.com',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(12.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF033A30)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
            child: IconButton(
              iconSize: 36,
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ),
        ],
      ),
    );
  }
}
