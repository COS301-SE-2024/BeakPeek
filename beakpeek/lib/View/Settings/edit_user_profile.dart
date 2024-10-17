import 'dart:convert';
import 'dart:io';

import 'package:beakpeek/Model/UserProfile/user_model.dart';
import 'package:beakpeek/Model/nav.dart';
import 'package:beakpeek/config_azure.dart';
import 'package:flutter/material.dart';
import 'package:beakpeek/Styles/colors.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class EditUserProfile extends StatefulWidget {
  const EditUserProfile({super.key});

  @override
  State<EditUserProfile> createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  final myController = TextEditingController();
  ImageProvider profilePicture =
      Image.memory(base64Decode(user.profilepicture)).image;
  final picker = ImagePicker();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Prevent Scaffold from resizing when keyboard opens
      backgroundColor: AppColors.backgroundColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.iconColor(context)),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(
          'Edit Profile',
          style: GlobalStyles.smallHeadingPrimary(context),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: screenHeight * 0.1, // Extra padding for scrolling
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Picture Section
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: screenWidth * 0.18,
                              backgroundImage: profilePicture,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  _showSelectionDialog();
                                },
                                child: CircleAvatar(
                                  backgroundColor:
                                      AppColors.popupColor(context),
                                  radius: screenWidth * 0.06,
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: screenWidth * 0.05,
                                    color: AppColors.iconColor(context),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      // Username Field
                      _buildTextField(
                        screenWidth: screenWidth,
                        fieldText: 'Username',
                        initialValue: user.username,
                        icon: Icons.person_outline,
                        onChanged: (value) {
                          user.username = value;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Bio Field
                      _buildTextField(
                        screenWidth: screenWidth,
                        fieldText: 'Bio',
                        initialValue: user.description,
                        icon: Icons.info_outline,
                        onChanged: (value) {
                          user.description = value;
                        },
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Save Button Positioned at the Bottom
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.1,
                vertical: screenHeight * 0.02,
              ),
              child: ElevatedButton(
                onPressed: () {
                  storeUserLocally(user);
                  updateOnline();
                  context.goNamed('profile');
                },
                style: GlobalStyles.buttonPrimaryFilled(context),
                child: Text(
                  'Save',
                  style: GlobalStyles.primaryButtonText(context),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }

  Widget _buildTextField({
    required double screenWidth,
    required String fieldText,
    required String initialValue,
    required IconData icon,
    required Function(String) onChanged,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.popupColor(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: TextEditingController()..text = initialValue,
        maxLines: maxLines,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: fieldText,
          labelStyle:
              GlobalStyles.smallContentPrimary(context).copyWith(fontSize: 17),
          prefixIcon: Icon(
            icon,
            size: screenWidth * 0.06,
            color: AppColors.iconColor(context),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        ),
      ),
    );
  }

  Future selectOrTakePhoto(ImageSource imageSource) async {
    final pickedFile = await picker.pickImage(source: imageSource);
    setState(
      () {
        if (pickedFile != null) {
          final bytes = File(pickedFile.path).readAsBytesSync();
          final String encodedImage = base64Encode(bytes);
          user.profilepicture = encodedImage;
          storeUserLocally(user);
        }
      },
    );
  }

  Future _showSelectionDialog() async {
    await showDialog(
      builder: (context) => SimpleDialog(
        title: const Text('Select photo'),
        children: <Widget>[
          SimpleDialogOption(
            child: const Text('From gallery'),
            onPressed: () {
              selectOrTakePhoto(ImageSource.gallery);
              Navigator.pop(context);
            },
          ),
          SimpleDialogOption(
            child: const Text('Take a photo'),
            onPressed: () {
              selectOrTakePhoto(ImageSource.camera);
              context.pop();
            },
          ),
        ],
      ),
      context: context,
    );
  }
}
