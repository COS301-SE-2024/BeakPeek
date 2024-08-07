import 'package:beakpeek/Model/achievement.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AchievementsProvider {
  AchievementsProvider._internal();
  static final AchievementsProvider instance = AchievementsProvider._internal();

  static Database? achievements;

  Future<Database> get database async {
    if (achievements != null) {
      return achievements!;
    }

    achievements = await _initDatabase();
    return achievements!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'achievements.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE achievement(
          id INTEGER PRIMARY KEY, 
          achievement TEXT,
          description TEXT
          )''',
        );
      },
    );
  }

  Future<void> insertAchievement(Achievement achieve) async {
    final db = await instance.database;
    if (!await isDuplicate(achieve)) {
      await db.insert(
        'achievement',
        achieve.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<Achievement>> fetchAchievementsList() async {
    final db = await instance.database;

    final List<Map<String, Object?>> achievementsMap = await db.query(
      'achievement',
      orderBy: 'id',
    );
    return [
      for (final {
            'name': name as String,
            'description': description as String,
          } in achievementsMap)
        Achievement(name: name, description: description),
    ];
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<bool> isDuplicate(Achievement achieve) async {
    final db = await instance.database;
    final maps = await db.query(
      'achieve',
      columns: ['name', 'description'],
      where: 'name = ? and description = ?',
      whereArgs: [achieve.name, achieve.description],
    );

    if (maps.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> delete(Achievement achieve) async {
    final db = await instance.database;
    await db.delete(
      'achievement',
      where: '''name = ? and description = ?''',
      whereArgs: [achieve.name, achieve.description],
    );
  }
}
