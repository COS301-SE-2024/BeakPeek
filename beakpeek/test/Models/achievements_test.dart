import 'package:beakpeek/Model/UserProfile/achievement.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Achievement', () {
    test('fromJson creates an Achievement object correctly', () {
      const jsonString = '''
      {
        "id": 1,
        "name": "First Achievement",
        "xp": 100,
        "description": "Achieve something",
        "icon": "base64IconString",
        "category": "General",
        "progress": 0.5,
        "iconname": "example_icon"
      }
      ''';

      final achievement = Achievement.fromJson(jsonString);

      expect(achievement.id, 1);
      expect(achievement.name, 'First Achievement');
      expect(achievement.xp, 100);
      expect(achievement.description, 'Achieve something');
      expect(achievement.icon, 'base64IconString');
      expect(achievement.category, 'General');
      expect(achievement.progress, 0.5);
      expect(achievement.iconname, 'example_icon');
    });

    test('fromMap creates an Achievement object correctly', () {
      final map = {
        'id': 2,
        'name': 'Second Achievement',
        'xp': 200,
        'description': 'Achieve another thing',
        'icon': 'anotherBase64IconString',
        'category': 'Advanced',
        'progress': 0.75,
        'iconname': 'example_icon_2'
      };

      final achievement = Achievement.fromMap(map);

      expect(achievement.id, 2);
      expect(achievement.name, 'Second Achievement');
      expect(achievement.xp, 200);
      expect(achievement.description, 'Achieve another thing');
      expect(achievement.icon, 'anotherBase64IconString');
      expect(achievement.category, 'Advanced');
      expect(achievement.progress, 0.75);
      expect(achievement.iconname, 'example_icon_2');
    });

    test('toMap converts Achievement object to map correctly', () {
      final achievement = Achievement(
        id: 3,
        name: 'Third Achievement',
        xp: 300,
        description: 'Achieve yet another thing',
        icon: 'someBase64IconString',
        category: 'Expert',
        progress: 1.0,
        iconname: 'example_icon_3',
      );

      final map = achievement.toMap();

      expect(map['id'], 3);
      expect(map['name'], 'Third Achievement');
      expect(map['xp'], 300);
      expect(map['description'], 'Achieve yet another thing');
      expect(map['icon'], 'someBase64IconString');
      expect(map['category'], 'Expert');
      expect(map['progress'], 1.0);
      expect(map['iconname'], 'example_icon_3');
    });

    test('toJson converts Achievement object to JSON string correctly', () {
      final achievement = Achievement(
        id: 4,
        name: 'Fourth Achievement',
        xp: 400,
        description: 'Yet another achievement',
        icon: 'someBase64IconString',
        category: 'Master',
        progress: 0.25,
        iconname: 'example_icon_4',
      );

      final jsonString = achievement.toJson();
      const expectedJsonString =
          '''{"id":4,"name":"Fourth Achievement","xp":400,"description":"Yet another achievement","icon":"someBase64IconString","category":"Master","progress":0.25,"iconname":"example_icon_4"}''';

      expect(jsonString, expectedJsonString);
    });

    // Test for getIcon method if necessary
    // This would typically require a mock or actual image icon
    // Add more tests as needed, especially if the getIcon method interacts with external dependencies
  });
}
