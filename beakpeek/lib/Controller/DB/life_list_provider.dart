import 'package:beakpeek/Model/bird.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LifeListProvider {
  LifeListProvider._internal();
  static final LifeListProvider instance = LifeListProvider._internal();

  static Database? lifeList;

  Future<Database> get database async {
    if (lifeList != null) {
      return lifeList!;
    }

    lifeList = await _initDatabase();
    return lifeList!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'life_list.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE birds(
          id INTEGER PRIMARY KEY, 
          pentad TEXT, 
          spp INTEGER, 
          commonGroup TEXT, 
          commonSpecies TEXT, 
          genus TEXT, 
          species TEXT, 
          reportingRate DOUBLE
          )''',
        );
      },
    );
  }

  Future<void> insertBird(Bird bird) async {
    final db = await instance.database;
    if (!await isDuplicate(bird)) {
      await db.insert(
        'birds',
        bird.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<Bird>> fetchLifeList() async {
    final db = await instance.database;

    final List<Map<String, Object?>> birdMap = await db.query(
      'birds',
      orderBy: 'commonGroup DESC, commonSpecies DESC',
    );
    return [
      for (final {
            'pentad': pentad as String,
            'spp': spp as int,
            'commonGroup': commonGroup as String,
            'commonSpecies': commonSpecies as String,
            'genus': genus as String,
            'species': species as String,
            'reportingRate': reportingRate as double,
          } in birdMap)
        Bird(
          pentad: pentad,
          spp: spp,
          commonGroup: commonGroup,
          commonSpecies: commonSpecies,
          genus: genus,
          species: species,
          reportingRate: reportingRate,
        ),
    ];
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<bool> isDuplicate(Bird bird) async {
    final db = await instance.database;
    final maps = await db.query(
      'birds',
      columns: ['commonGroup', 'commonSpecies', 'genus', 'species'],
      where:
          'commonGroup = ? AND commonSpecies = ? AND genus = ? AND species =?',
      whereArgs: [
        bird.commonGroup,
        bird.commonSpecies,
        bird.genus,
        bird.species
      ],
    );

    if (maps.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> delete(Bird bird) async {
    final db = await instance.database;
    await db.delete(
      'birds',
      where:
          '''commonGroup = ? AND commonSpecies = ? AND genus = ? AND species =?''',
      whereArgs: [
        bird.commonGroup,
        bird.commonSpecies,
        bird.genus,
        bird.species
      ],
    );
  }
}
