import 'package:beakpeek/Model/nav.dart';
import 'package:beakpeek/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.iconColor(context)),
          onPressed: () {
            context.go('/profile');
          },
        ),
        title:
            Text('Settings', style: GlobalStyles.smallHeadingPrimary(context)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: screenHeight * 0.02,
          left: screenWidth * 0.01,
          right: screenWidth * 0.01,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            ListTile(
              title: const Text('Option 1'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle option 1 tap
              },
            ),
            ListTile(
              title: const Text('Option 2'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle option 2 tap
              },
            ),
            const Spacer(),
            const BottomNavigation(),
          ],
        ),
      ),
    );
  }
}
