import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:beakpeek/Model/UserProfile/achievement.dart';
import 'package:beakpeek/Model/UserProfile/achievment_list.dart';
import 'package:beakpeek/Model/UserProfile/user_model.dart';
import 'package:beakpeek/Model/help_icon.dart';
import 'package:beakpeek/Model/nav.dart';
import 'package:beakpeek/Styles/colors.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => AchievementsPageState();
}

class AchievementsPageState extends State<AchievementsPage> {
  final LifeListProvider lifeList = LifeListProvider.instance;
  /* This final is what loads all achievements and also 
   * will be used to track achievement progress
   */
  late Future<AchievementList> _achievementlist = getAchivementList();
  @override
  void initState() {
    _achievementlist = getAchivementList();
    updateOnline();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.iconColor(context)),
          onPressed: () {
            context.go('/home');
          },
        ),
        title: Text('Achievements',
            style: GlobalStyles.smallHeadingPrimary(context)),
        centerTitle: true,
        actions: const [
          HelpIcon(
              content:
                  '''Follow the instructions to get the achievement! \n\nThis will earn you some profile experience points and helps you unlock ultimate bragging rights.'''),
          SizedBox(width: 14.0)
        ],
      ),
      bottomNavigationBar: const BottomNavigation(),
      body: FutureBuilder<AchievementList>(
          future: _achievementlist,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: AppColors.iconColor(context),
              ));
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error loading achievements: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData ||
                snapshot.data!.achievements.isEmpty) {
              return const Center(
                child: Text('No achievements found.'),
              );
            }

            return Scrollbar(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (String category in getAchievementCategories())
                          AchievementSection(
                              title: category,
                              achievements: getAchievementByCategory(category))
                      ]),
                ),
              ),
            );
          }),
    );
  }
}

class AchievementSection extends StatelessWidget {
  const AchievementSection(
      {super.key, required this.title, required this.achievements});

  final String title;
  final List<Achievement> achievements;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GlobalStyles.smallHeadingPrimary(context).copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: achievements
              .map((achievement) => AchievementTile(achievement: achievement))
              .toList(),
        ),
      ],
    );
  }
}

class AchievementTile extends StatelessWidget {
  const AchievementTile({super.key, required this.achievement});

  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.popupColor(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            achievement.getIcon(40, AppColors.tertiaryColor(context)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement.name,
                    style: GlobalStyles.contentPrimary(context).copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    achievement.description,
                    style: GlobalStyles.smallContentPrimary(context),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: achievement.progress,
                    backgroundColor: Colors.grey[300],
                    color: AppColors.tertiaryColor(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
