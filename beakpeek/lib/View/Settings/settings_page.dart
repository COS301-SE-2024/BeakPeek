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
            _buildSectionHeader(context, 'Your Account'),
            _buildOptionTile(context, 'Edit Personal Information', Icons.edit,
                Icons.arrow_forward_ios, () {
              // Handle Edit Personal Information tap
            }),
            _buildOptionTile(context, 'Delete Account', Icons.delete,
                Icons.arrow_forward_ios, () {
              // Handle Delete Account tap
            }),
            const SizedBox(height: 20),

            _buildSectionHeader(context, 'App Settings'),
            _buildToggleThemeTile(context), // Dark mode toggle
            _buildOptionTile(context, 'Notifications', Icons.notifications,
                Icons.arrow_forward_ios, () {
              // Handle Notifications tap
            }),
            _buildOptionTile(context, 'Privacy Settings', Icons.lock,
                Icons.arrow_forward_ios, () {
              // Handle Privacy Settings tap
            }),
            const SizedBox(height: 20),

            _buildSectionHeader(context, 'Support'),
            _buildOptionTile(context, 'Help & Support', Icons.help_outline,
                Icons.arrow_forward_ios, () {
              // Handle Help & Support tap
            }),
            _buildOptionTile(
                context, 'Legal Policies', Icons.gavel, Icons.arrow_forward_ios,
                () {
              // Handle Legal Policies tap
            }),
            _buildOptionTile(
                context, 'About', Icons.info_outline, Icons.arrow_forward_ios,
                () {
              // Handle About tap
            }),
            const Spacer(),
            const BottomNavigation(),
          ],
        ),
      ),
    );
  }

  // Builds the section header text
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, top: 20.0),
      child: Text(
        title,
        style: GlobalStyles.smallHeadingPrimary(context),
      ),
    );
  }

  // Builds the general option tiles
  Widget _buildOptionTile(BuildContext context, String title,
      IconData leadingIcon, IconData trailingIcon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
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
        leading: Icon(leadingIcon, color: AppColors.iconColor(context)),
        title: Text(title, style: GlobalStyles.contentPrimary(context)),
        trailing: Icon(trailingIcon, color: AppColors.iconColor(context)),
        onTap: onTap,
      ),
    );
  }

  // Builds the toggle theme option with dynamic icon on the left
  Widget _buildToggleThemeTile(BuildContext context) {
    final isDarkMode =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
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
        leading: Icon(
          isDarkMode ? Icons.nights_stay_outlined : Icons.wb_sunny_outlined,
          color: AppColors.iconColor(context),
        ),
        title:
            Text('Toggle Theme', style: GlobalStyles.contentPrimary(context)),
        trailing: Switch(
          value: isDarkMode,
          onChanged: (value) {
            Provider.of<ThemeProvider>(context, listen: false)
                .toggleTheme(!isDarkMode);
          },
          activeColor: AppColors.primaryColor(context),
          inactiveThumbColor: AppColors.primaryColor(context),
          activeTrackColor: AppColors.backgroundColor(context),
          inactiveTrackColor: AppColors.backgroundColor(context),
        ),
      ),
    );
  }
}