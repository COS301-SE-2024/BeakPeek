// user_model_test.dart

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:beakpeek/Model/UserProfile/user_achievment.dart';
import 'package:beakpeek/Model/UserProfile/user_model.dart';

void main() {
  group('UserModel Tests', () {
    // Sample JSON data for testing
    const String jsonString = '''
    {
      "username": "testUser",
      "email": "test@example.com",
      "profilepicture": "https://example.com/profile.jpg",
      "achievements": [
        {"id": 1, "progress": 0.5},
        {"id": 2, "progress": 1.0}
      ],
      "description": "Test user description",
      "level": 2,
      "xp": 100,
      "lifelist": "[{'id': 1}]",
      "highscore": 50
    }
    ''';

    // Test for creating UserModel from JSON
    test('UserModel.fromJson creates an instance from valid JSON', () {
      final userModel = UserModel.fromJson(jsonString);
      expect(userModel.username, 'testUser');
      expect(userModel.email, 'test@example.com');
      expect(userModel.profilepicture, 'https://example.com/profile.jpg');
      expect(userModel.achievements.length, 2);
      expect(userModel.level, 2);
      expect(userModel.xp, 100);
      expect(userModel.lifelist, '[{\'id\': 1}]');
      expect(userModel.highscore, 50);
    });

    // Test for converting UserModel to JSON
    test('UserModel.toJson converts an instance to JSON', () {
      final userModel = UserModel(
        username: 'testUser',
        email: 'test@example.com',
        profilepicture: 'https://example.com/profile.jpg',
        achievements: [
          UserAchievement(id: 1, progress: 0.5),
          UserAchievement(id: 2, progress: 1.0),
        ],
        description: 'Test user description',
        level: 2,
        xp: 100,
        lifelist: '[{\'id\': 1}]',
        highscore: 50,
      );

      final jsonOutput = userModel.toJson();
      final expectedJson = json.decode(jsonString);
      expect(json.decode(jsonOutput), expectedJson);
    });

    // Test for get() method
    test('UserModel.get retrieves properties correctly', () {
      final userModel = UserModel.fromJson(jsonString);
      expect(userModel.get('username'), 'testUser');
      expect(userModel.get('level'), 2);
      expect(userModel.get('xp'), 100);
    });

    // Test for set() method
    test('UserModel.set updates properties correctly', () {
      final userModel = UserModel.fromJson(jsonString);
      userModel.set('level', 4);
      expect(userModel.level, 4);
      expect(() => userModel.set('nonexistentProperty', 'value'),
          throwsArgumentError);
    });
  });
}
