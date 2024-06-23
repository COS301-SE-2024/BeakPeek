import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({required this.change, super.key});
  const UserProfile.changeTheme(this.change, {super.key});
  final Function() change;
  @override
  State<UserProfile> createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('The mode is ${localStorage.getItem('theme') ?? 'light'}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.change();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
