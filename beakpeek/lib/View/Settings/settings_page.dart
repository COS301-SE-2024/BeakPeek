import 'package:beakpeek/Model/nav.dart';
import 'package:beakpeek/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:beakpeek/Controller/Main/theme_provider.dart';

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
          left: screenWidth * 0.03,
          right: screenWidth * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildOptionTile(
                context, 'Edit Personal Information', Icons.arrow_forward_ios,
                () {
              // Handle option 1 tap
            }),
            const SizedBox(height: 10),
            _buildToggleThemeTile(context), // Dark mode toggle
            const SizedBox(height: 10),
            _buildOptionTile(context, 'Legal Policies', Icons.arrow_forward_ios,
                () {
              // Handle option 2 tap
            }),
            const SizedBox(height: 10),
            _buildOptionTile(context, 'Delete Account', Icons.arrow_forward_ios,
                () {
              // Handle option 2 tap
            }),
            const Spacer(),
            const BottomNavigation(),
          ],
        ),
      ),
    );
  }

  // Builds the general option tiles
  Widget _buildOptionTile(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.popupColor(context),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        title: Text(title, style: GlobalStyles.contentPrimary(context)),
        trailing: Icon(icon, color: AppColors.iconColor(context)),
        onTap: onTap,
      ),
    );
  }

  // Builds the toggle theme option with dynamic icon
  Widget _buildToggleThemeTile(BuildContext context) {
    final isDarkMode =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.popupColor(context),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        title:
            Text('Toggle Theme', style: GlobalStyles.contentPrimary(context)),
        trailing: Icon(
          isDarkMode ? Icons.nights_stay_outlined : Icons.wb_sunny_outlined,
          color: AppColors.iconColor(context),
        ),
        onTap: () {
          Provider.of<ThemeProvider>(context, listen: false)
              .toggleTheme(!isDarkMode);
        },
      ),
    );
  }
}
