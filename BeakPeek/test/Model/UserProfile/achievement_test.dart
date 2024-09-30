import 'dart:convert';
import 'package:beakpeek/Model/UserProfile/achievement.dart';
import 'package:flutter_test/flutter_test.dart';
// Adjust the import to your actual file path

void main() {
  group('Achievement', () {
    // Test the factory method fromJson
    test('fromJson creates an Achievement from JSON string', () {
      const String jsonString = '''
      {
        "id": 1,
        "name": "Birdwatching Expert",
        "xp": 100,
        "description": "Observe and identify 50 species of birds.",
        "icon": "base64String",
        "category": "Birdwatching",
        "progress": 75.0,
        "iconname": "bird_icon"
      }
      ''';

      final Achievement achievement = Achievement.fromJson(jsonString);

      expect(achievement.id, 1);
      expect(achievement.name, 'Birdwatching Expert');
      expect(achievement.xp, 100);
      expect(
          achievement.description, 'Observe and identify 50 species of birds.');
      expect(achievement.icon, 'base64String');
      expect(achievement.category, 'Birdwatching');
      expect(achievement.progress, 75.0);
      expect(achievement.iconname, 'bird_icon');
    });

    // Test the factory method fromMap
    test('fromMap creates an Achievement from a Map', () {
      final Map<String, dynamic> map = {
        'id': 2,
        'name': 'Nature Lover',
        'xp': 50,
        'description': 'Explore the beauty of nature.',
        'icon': '',
        'category': 'Nature',
        'progress': 30.0,
        'iconname': 'nature_icon'
      };

      final Achievement achievement = Achievement.fromMap(map);

      expect(achievement.id, 2);
      expect(achievement.name, 'Nature Lover');
      expect(achievement.xp, 50);
      expect(achievement.description, 'Explore the beauty of nature.');
      expect(achievement.icon, '');
      expect(achievement.category, 'Nature');
      expect(achievement.progress, 30.0);
      expect(achievement.iconname, 'nature_icon');
    });

    // Test the toJson method
    test('toJson converts Achievement to JSON string', () {
      final Achievement achievement = Achievement(
        id: 3,
        name: 'Wildlife Enthusiast',
        xp: 200,
        description: 'Engage with wildlife in their natural habitat.',
        icon: 'anotherBase64String',
        category: 'Wildlife',
        progress: 90.0,
        iconname: 'wildlife_icon',
      );

      final String jsonString = achievement.toJson();
      final Map<String, dynamic> decodedJson = json.decode(jsonString);

      expect(decodedJson['id'], 3);
      expect(decodedJson['name'], 'Wildlife Enthusiast');
      expect(decodedJson['xp'], 200);
      expect(decodedJson['description'],
          'Engage with wildlife in their natural habitat.');
      expect(decodedJson['icon'], 'anotherBase64String');
      expect(decodedJson['category'], 'Wildlife');
      expect(decodedJson['progress'], 90.0);
      expect(decodedJson['iconname'], 'wildlife_icon');
    });

    // Test the getIcon method
  });
}
