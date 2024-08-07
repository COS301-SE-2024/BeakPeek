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
  
  return birdMap.map((map) {
    return Bird(
      id: map['id'] as int,
      commonGroup: map['commonGroup'] as String,
      commonSpecies: map['commonSpecies'] as String,
      fullProtocolRR: map['fullProtocolRR'] != null ? map['fullProtocolRR'] as double : 0.0,
      fullProtocolNumber: map['fullProtocolNumber'] != null ? map['fullProtocolNumber'] as int : 0,
      latestFP: map['latestFP'] as String,
      reportingRate: map['reportingRate'] != null ? map['reportingRate'] as double : 0.0,
      genus: map['genus'] as String,
      species: map['species'] as String,
      pentad: Pentad(
        pentadAllocation: map['pentad'] as String,
        pentadLongitude: map['pentadLongitude'] != null ? map['pentadLongitude'] as double : 0.0,
        pentadLatitude: map['pentadLatitude'] != null ? map['pentadLatitude'] as double : 0.0,
        province: Province(
          id: map['provinceId'] as int,
          name: map['provinceName'] as String,
          birds: null, // Adjust this according to your needs
        ),
        totalCards: map['totalCards'] != null ? map['totalCards'] as int : 0,
      ),
      jan: map['jan'] != null ? map['jan'] as double : 0.0,
      feb: map['feb'] != null ? map['feb'] as double : 0.0,
      mar: map['mar'] != null ? map['mar'] as double : 0.0,
      apr: map['apr'] != null ? map['apr'] as double : 0.0,
      may: map['may'] != null ? map['may'] as double : 0.0,
      jun: map['jun'] != null ? map['jun'] as double : 0.0,
      jul: map['jul'] != null ? map['jul'] as double : 0.0,
      aug: map['aug'] != null ? map['aug'] as double : 0.0,
      sep: map['sep'] != null ? map['sep'] as double : 0.0,
      oct: map['oct'] != null ? map['oct'] as double : 0.0,
      nov: map['nov'] != null ? map['nov'] as double : 0.0,
      dec: map['dec'] != null ? map['dec'] as double : 0.0,
      totalRecords: map['totalRecords'] != null ? map['totalRecords'] as int : 0,
    );
  }).toList();
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
