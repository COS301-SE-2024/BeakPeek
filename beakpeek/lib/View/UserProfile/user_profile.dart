import 'package:beakpeek/Model/user_profile_function.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:profile_photo/profile_photo.dart';
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
      body: Center(
        child: Column(
          children: [
            ProfilePhoto(
              totalWidth: 200,
              cornerRadius: 100,
              color: Colors.blue,
              outlineColor: Colors.red,
              outlineWidth: 5,
              name: name,
              image: Image.asset(
                'assets/images/profileImages/images.jpg',
              ).image,
            ),
            TextField(
              maxLines: 2,
              onChanged: (value) => editName(value),
              decoration: const InputDecoration(
                label: Text('Full name'),
                hintText: 'Elm Boog',
              ),
            ),
            //fullname
            const Center(
              child: Text('Live List'),
            ),
            Container(
              child: getLiveList(),
            ),
            Center(
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
                label: Text(iconLabel),
              ),
            ),
            Center(
              child: FilledButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF033A30),
                  minimumSize: const Size(350, 50),
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
            ),
          ],
        ),
      ),
    );
  }
}
