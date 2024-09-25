import 'package:beakpeek/Model/nav.dart';
import 'package:beakpeek/Styles/colors.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

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
      ),
      bottomNavigationBar: const BottomNavigation(),
      body: const Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AchievementSection(
                  title: 'Provincial Achievements',
                  achievements: [
                    Achievement(
                      title: 'Gauteng Explorer',
                      description: 'Spot birds in Gauteng',
                      progress: 0.75,
                      badge: Icons.location_on,
                    ),
                    Achievement(
                      title: 'Western Cape Wanderer',
                      description: 'Spot birds in Western Cape',
                      progress: 0.3,
                      badge: Icons.location_on,
                    ),
                    Achievement(
                      title: 'Mpumalanga Adventurer',
                      description: 'Spot birds in Mpumalanga',
                      progress: 0.3,
                      badge: Icons.location_on,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                AchievementSection(
                  title: 'Bird Species Achievements',
                  achievements: [
                    Achievement(
                      title: 'Waterfowl Watcher',
                      description: 'Spot all birds in the Waterfowl species',
                      progress: 0.6,
                      badge: Icons.water,
                    ),
                    Achievement(
                      title: 'Raptor Ranger',
                      description: 'Spot all birds in the Raptor species',
                      progress: 0.2,
                      badge: Icons.flight,
                    ),
                    Achievement(
                      title: 'Songbird Specialist',
                      description: 'Spot all birds in the Songbird species',
                      progress: 0.4,
                      badge: Icons.music_note,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                AchievementSection(
                  title: 'Monthly Achievements',
                  achievements: [
                    Achievement(
                      title: '15 Birds in 3 Months',
                      description: 'See 15 birds for 3 consecutive months',
                      progress: 0.8,
                      badge: Icons.calendar_today,
                    ),
                    Achievement(
                      title: 'Quiz Master',
                      description: 'Get 10 quizzes correct in a row',
                      progress: 0.0,
                      badge: Icons.quiz,
                    ),
                    Achievement(
                      title: 'Birding Streak',
                      description: 'Go birdwatching for 7 consecutive days',
                      progress: 0.9,
                      badge: Icons.trending_up,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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

class Achievement {
  const Achievement({
    required this.title,
    required this.description,
    required this.progress,
    required this.badge,
  });

  final String title;
  final String description;
  final double progress;
  final IconData badge;
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
            Icon(
              achievement.badge,
              size: 40,
              color: AppColors.tertiaryColor(context),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement.title,
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
