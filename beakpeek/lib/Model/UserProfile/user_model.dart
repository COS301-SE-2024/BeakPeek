// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:beakpeek/config_azure.dart';
import 'package:http/http.dart' as http;
import 'package:beakpeek/Model/UserProfile/achievement.dart';
import 'package:localstorage/localstorage.dart';

class UserModel {
  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
// TODO: Update api so that it returns every key in lowercase

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['userName'] ?? map['username'],
      email: map['email'],
      profilepicture: map['profilePicture'] ?? map['profilepicture'] ?? '',
      achievements: List<Achievement>.from(
          map['achievements']?.map((x) => Achievement.fromMap(x))),
      description: map['description'] ?? 'Tell us about yourself...',
      level: map['level'] ?? 0,
      xp: map['xp'],
      lifelist: map['lifelist'],
    );
  }

  UserModel({
    this.username = 'Unknown',
    this.email = '',
    this.profilepicture = '',
    this.achievements = const [],
    this.description = '',
    this.xp = 0,
    this.lifelist = '',
    this.level = 0,
  });

  String username;
  String email;
  String profilepicture;
  List<Achievement> achievements;
  String description;
  int level;
  int xp;
  String lifelist;

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
  }

  String toJson() => json.encode(toMap());
}

Future<UserModel> getOnlineUser() async {
  final response = await http.get(Uri.parse('$userApiUrl/User/Profile'),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'});
  return UserModel.fromJson(response.body);
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

Future<void> updateOnline() async {
  //TODO: user update

  print('updated');
}