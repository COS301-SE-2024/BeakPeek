import 'package:beakpeek/Model/UserProfile/user_model.dart';
import 'package:beakpeek/Model/nav.dart';
import 'package:beakpeek/Styles/colors.dart';
import 'package:beakpeek/View/UserProfile/color_palette.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:beakpeek/Controller/Main/theme_provider.dart';
import 'package:beakpeek/Controller/DB/import_export.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  PDFDocument? document;
  bool viewTandC = false;

  void loadPdfT() {
    setState(() {
      viewTandC = true;
    });
  }

  void loadPDf() async {
    document = await PDFDocument.fromAsset('assets/Legal/combinepdf.pdf');
  }

  void loadPDfU() async {
    document = await PDFDocument.fromAsset('assets/Legal/UserManual.pdf');
    setState(() {
      viewTandC = true;
    });
  }

  @override
  void initState() {
    loadPDf();
    super.initState();
  }

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
            context.pop();
          },
        ),
        title:
            Text('Settings', style: GlobalStyles.smallHeadingPrimary(context)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: screenHeight * 0.02),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(context, 'Your Account'),
                  _buildOptionTile(
                    context,
                    'Delete Account',
                    Icons.delete, // Changed icon
                    Icons.arrow_forward_ios,
                    () {
                      deleteLocalUser();
                      context.pop();
                    },
                  ),
                  _buildOptionTile(
                    context,
                    'Export Life List',
                    Icons.download, // Changed icon
                    Icons.arrow_forward_ios,
                    () {
                      ImportExport().exportLifeList();
                    },
                  ),
                  _buildOptionTile(
                    context,
                    'Import Life List', // New option
                    Icons.upload, // Correct icon for importing
                    Icons.arrow_forward_ios,
                    () {
                      ImportExport().importLifeList();
                    },
                  ),
                  _buildOptionTile(
                    context,
                    'Logout',
                    Icons.logout,
                    Icons.arrow_forward_ios,
                    () {
                      logoutUser();
                      context.go('/');
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildSectionHeader(context, 'App Settings'),
                  _buildToggleThemeTile(context), // Dark mode toggle
                  _buildOptionTile(
                    context,
                    'Colour Palette',
                    Icons.palette, // Correct icon for color palette
                    Icons.arrow_forward_ios,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaletteSelector(),
                        ),
                      );
                    },
                  ),
                  _buildOptionTile(
                    context,
                    'Privacy Settings',
                    Icons.lock,
                    Icons.arrow_forward_ios,
                    () {
                      // Handle Privacy Settings tap
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildSectionHeader(context, 'Support'),
                  _buildOptionTile(
                    context,
                    'Help & Support',
                    Icons.help_outline,
                    Icons.arrow_forward_ios,
                    () {
                      loadPDfU();
                    },
                  ),
                  _buildOptionTile(
                    context,
                    'Legal Policies',
                    Icons.gavel,
                    Icons.arrow_forward_ios,
                    () {
                      loadPdfT();
                    },
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  viewTandC
                      ? SizedBox(
                          height: screenHeight * 0.75,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                flex: (screenHeight * 0.5).floor(),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.popupColor(context),
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  child: PDFViewer(
                                    document: document!,
                                    zoomSteps: 3,
                                    lazyLoad: false,
                                    scrollDirection: Axis.vertical,
                                    pickerButtonColor: AppColors.popupColorDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(
                          height: 0,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigation(),
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
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        color: AppColors.popupColor(context),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
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
