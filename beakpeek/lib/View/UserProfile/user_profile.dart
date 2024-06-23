import 'package:beakpeek/Model/user_profile_function.dart';
import 'package:flutter/material.dart';
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
  @override
  void initState() {
    iconDisplay = getIcon();
    iconLabel = getLabelIcon();
    super.initState();
  }

  void changeIcon() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            //profile photo
            //fullname
            //livelist
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
          ],
        ),
      ),
    );
  }
}
