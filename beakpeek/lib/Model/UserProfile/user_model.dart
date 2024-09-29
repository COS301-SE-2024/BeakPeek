// ignore_for_file: avoid_print

import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:beakpeek/Model/UserProfile/achievment_list.dart';
import 'package:beakpeek/Model/UserProfile/user_achievment.dart';
import 'package:beakpeek/config_azure.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class UserModel {
  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        username: map['userName'] ?? map['username'],
        email: map['email'],
        profilepicture: map['profilePicture'] ?? map['profilepicture'] ?? '',
        achievements: List<UserAchievement>.from(
            map['achievements']?.map((x) => UserAchievement.fromMap(x))),
        description: map['description'] ?? 'Tell us about yourself...',
        level: map['level'] ?? 1,
        xp: map['xp'] ?? 0,
        lifelist: map['lifelist'] ?? '',
        highscore: map['highscore'] ?? 0);
  }

  UserModel(
      {this.username = 'Unknown',
      this.email = '',
      this.profilepicture = '',
      this.achievements = const [],
      this.description = '',
      this.xp = 0,
      this.lifelist = '',
      this.level = 1,
      this.highscore = 0});

  String username;
  String email;
  String profilepicture;
  List<UserAchievement> achievements;
  String description;
  int level;
  int xp;
  String lifelist;
  int highscore;

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'profilepicture': profilepicture,
      'achievements': achievements.map((x) => x.toMap()).toList(),
      'description': description,
      'xp': xp,
      'level': level,
      'lifelist': lifelist,
      'highscore': highscore
    };
  }

  dynamic get(String propertyName) {
    propertyName = propertyName.toLowerCase();
    final mapRep = toMap();
    if (mapRep.containsKey(propertyName)) {
      return mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }

  void set(String propertyName, dynamic value) {
    propertyName = propertyName.toLowerCase();
    if (value == null) {
      return;
    }
    final mapRep = toMap();
    if (!mapRep.containsKey(propertyName)) {
      throw ArgumentError('property not found');
    }
    mapRep.update(propertyName, (x) => value);
    user = UserModel.fromMap(mapRep);
  }

  String toJson() => json.encode(toMap());
}

Future<UserModel> getOnlineUser() async {
  final response = await http.get(Uri.parse('$userApiUrl/User/Profile'),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'});

  if (response.statusCode != 200) {
    storeUserLocally(user);
    return user;
  }
  user = UserModel.fromJson(response.body);
  storeUserLocally(user);
  return user;
}

void storeUserLocally(UserModel user) {
  localStorage.setItem('user', user.toJson());
}

UserModel getLocalUser() {
  final String? userString = localStorage.getItem('user');
  if (userString == null) {
    // throw Exception('No Local User');
    print('no local user');
    return UserModel();
  }
  return UserModel.fromJson(userString);
}

void deleteLocalUser() {
  localStorage.setItem('user', '');
  final LifeListProvider lifelist = LifeListProvider.instance;
  lifelist.deleteDatabaseFile();
  localStorage.setItem('accessToken', '');
}

Future<void> updateOnline({LifeListProvider? lifelist}) async {
  // if (lifelist != null) {
  //   await lifelist.updateUserLifelist();
  // }
  final response = await http.post(Uri.parse('$userApiUrl/User/UpdateProfile'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        HttpHeaders.contentTypeHeader: 'application/json'
      },
      body: user.toJson());

  if (response.statusCode != 200) {
    storeUserLocally(user);
    return;
  }
  user = UserModel.fromJson(response.body);
  storeUserLocally(user);
}

void logoutUser() {
  updateOnline();
  user = UserModel();
  loggedIN = false;
  accessToken = '';
  achievementList = AchievementList();
  localStorage.clear();
}

Future<void> updateUsersAchievement(int id, double progress) async {
  final response = await http.post(
      Uri.parse('$userApiUrl/User/AddAchievement?id=$id&progress=$progress'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        HttpHeaders.contentTypeHeader: 'application/json'
      });

  if (response.statusCode == 200) {
    updateOnline();
  }

  final int achievementIndex =
      user.achievements.indexWhere((element) => element.id == id);

  if (achievementIndex == -1) {
    user.achievements.add(UserAchievement(id: id, progress: progress));
    return;
  }
  user.achievements[achievementIndex].progress = progress;

  storeUserLocally(user);
}

Future<void> updateAllUserAchievementsOnline() async {
  for (UserAchievement userAchievement in user.achievements) {
    final response = await http.post(
        Uri.parse(
            '$userApiUrl/User/AddAchievement?id=${userAchievement.id}&progress=${userAchievement.progress}'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          HttpHeaders.contentTypeHeader: 'application/json'
        });

    if (response.statusCode != 200) {
      return;
    }
  }
}
