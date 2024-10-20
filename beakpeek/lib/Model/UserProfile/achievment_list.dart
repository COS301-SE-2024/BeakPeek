// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Model/UserProfile/user_achievment.dart';
import 'package:beakpeek/Model/UserProfile/user_model.dart';
import 'package:beakpeek/config_azure.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:beakpeek/Model/UserProfile/achievement.dart';

final List<String> achivementNames = [
  'Risk it for the Biscuits',
  'Gauteng Explorer',
  'Watch The Waves',
  'Limpopo Hoopoe',
  'Mpumalanga Adventurer',
  'Diamond Hunter',
  'Directionally challenged',
  'Western Cape Wanderer',
  'Freesest Alive'
];

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

  final LifeListProvider lifelist = LifeListProvider.instance;
  final List<Bird> birdsLife = await lifelist.fetchLifeList();
  for (Bird bird in birdsLife) {
    switch (bird.commonGroup.toLowerCase()) {
      case 'weaver':
        await updateAchievmentProgressBirds('Weaver Believer', 'Weaver');
        break;
      case 'duck':
        await updateAchievmentProgressBirds('Duck Hunter', 'Duck');
        break;
      case 'eagle':
        await updateAchievmentProgressBirds('USA', 'Eagle');
        break;
      case 'kingfisher':
        await updateAchievmentProgressBirds('Fisherman', 'Kingfisher');
        break;
      case 'hawk':
        await updateAchievmentProgressBirds('Hawk Spotter', 'Hawk');
        break;
      case 'heron':
        await updateAchievmentProgressBirds('Heron Horror', 'Heron');
        break;
    }
    await updateProvinces(bird.id);
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

Future<void> updateLifeListAchievments(String commonGroup) async {}

Future<void> updateProvinces(int id) async {
  final List<String> achivementNames = [
    'Risk it for the Biscuits',
    'Gauteng Explorer',
    'Watch The Waves',
    'Limpopo Hoopoe',
    'Mpumalanga Adventurer',
    'Diamond Hunter',
    'Directionally challenged',
    'Western Cape Wanderer',
    'Freesest Alive'
  ];
  final LifeListProvider lifeList = LifeListProvider.instance;
  final List<double> progress = await lifeList.precentLifeListBirds();
  for (int i = 0; i < achivementNames.length; i++) {
    final Achievement? provMaster = getAchievementByName(achivementNames[i]);

    if (provMaster != null) {
      await updateUsersAchievement(provMaster.id, progress[i]);
      //print(achivementNames[i]);
    }
  }
}

/// All checks for user progress should go here
Future<void> updateAchievmentProgressBirds(
    String achievemntName, String commonGroup) async {
  /// Quiz Master
  final Achievement? birdMaster = getAchievementByName(achievemntName);
  final LifeListProvider lifeList = LifeListProvider.instance;
  if (birdMaster != null) {
    final int countBird = await lifeList.lifeBirdCount(commonGroup);
    final int totalBird = await lifeList.allBirdCount(commonGroup);
    double progress = countBird / totalBird;
    progress = progress < 1 ? progress : 1;
    await updateUsersAchievement(birdMaster.id, progress);
    //print(achievemntName);
  }
}
