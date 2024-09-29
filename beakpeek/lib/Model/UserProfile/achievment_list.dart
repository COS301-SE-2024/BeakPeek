import 'dart:convert';
import 'dart:io';
import 'package:beakpeek/Model/UserProfile/user_achievment.dart';
import 'package:beakpeek/Model/UserProfile/user_model.dart';
import 'package:beakpeek/config_azure.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:beakpeek/Model/UserProfile/achievement.dart';

class AchievementList {
  factory AchievementList.fromJson(String source) =>
      AchievementList.fromMap(json.decode(source));

  factory AchievementList.fromMap(Iterable map) {
    return AchievementList(
        achievements:
            List<Achievement>.from(map.map((x) => Achievement.fromMap(x))));
  }
  AchievementList({this.achievements = const []});

  List<Achievement> achievements;

  Map<String, dynamic> toMap() {
    return {'achievements': achievements.map((x) => x.toMap()).toList()};
  }

  String toJson() => json.encode(toMap());
}

/// Gets achievements online and checks progress of achievements
Future<AchievementList> getAchivementList() async {
  final response = await http.get(Uri.parse('$userApiUrl/User/GetAchievments'),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'});
  if (response.statusCode != 200) {
    return achievementList;
  }
  user = await getOnlineUser();
  achievementList = AchievementList.fromJson(response.body);
  storeAchievementListLocally(achievementList);
  await updateAchievmentProgress();
  return achievementList;
}

/// All checks for user progress should go here
Future<void> updateAchievmentProgress() async {
  /// Quiz Master
  final Achievement? quizMaster = getAchievementByName('Quiz Master');
  if (quizMaster != null) {
    double progress = user.highscore / 10;
    progress = progress < 1 ? progress : 1;
    await updateUsersAchievement(quizMaster.id, progress);
    for (UserAchievement ua in user.achievements) {
      print(ua.toJson());
    }
    print('Quiz Master');
  }

  for (UserAchievement userAchievement in user.achievements) {
    achievementList
        .achievements[achievementList.achievements
            .indexWhere((element) => element.id == userAchievement.id)]
        .progress = userAchievement.progress;
  }

  storeAchievementListLocally(achievementList);
}

List<Achievement> getAchievementByCategory(String category) {
  return achievementList.achievements
      .where((x) => x.category == category)
      .toList();
}

Achievement? getAchievementByName(String name) {
  return achievementList.achievements
      .firstWhere((a) => a.name == name, orElse: () => Achievement());
}

List<String> getAchievementCategories() {
  final categorySet = <String>{};
  for (Achievement achiement in achievementList.achievements) {
    categorySet.add(achiement.category);
  }
  return categorySet.toList();
}

void storeAchievementListLocally(AchievementList achievements) {
  localStorage.setItem('achievmentlist', achievements.toJson());
}

AchievementList? getLocalAchievmentList() {
  final String? userString = localStorage.getItem('achievmentlist');
  if (userString == null) {
    return null;
  }
  return AchievementList.fromJson(userString);
}
