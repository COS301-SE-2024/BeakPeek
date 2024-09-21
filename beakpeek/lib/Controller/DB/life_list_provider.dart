// ignore_for_file: avoid_print

import 'dart:async';

import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Model/BirdInfo/pentad.dart';
import 'package:beakpeek/Model/BirdInfo/province.dart';
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
      onCreate: _createDb,
    );
  }

  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'life_list.db');

    // Delete the database file
    await deleteDatabase(path);
    print('Database deleted');
  }

  Future _createDb(Database db, version) async {
    await db.execute('''CREATE TABLE birds(
          id INTEGER PRIMARY KEY, 
          commonGroup TEXT, 
          commonSpecies TEXT, 
          genus TEXT, 
          species TEXT, 
          reportingRate DOUBLE
          )''');
    await db.execute('''
        CREATE TABLE allBirds(
          id INTEGER PRIMARY KEY, 
          commonGroup TEXT, 
          commonSpecies TEXT, 
          genus TEXT, 
          species TEXT,
          fullProtocolRR REAL,
          fullProtocolNumber INTEGER,
          latestFP NUMERIC,
          jan DOUBLE,
          feb  DOUBLE,
          mar  DOUBLE,
          apr  DOUBLE,
          may  DOUBLE,
          jun  DOUBLE,
          jul  DOUBLE,
          aug  DOUBLE,
          sep  DOUBLE,
          oct  DOUBLE,
          nov DOUBLE,
          dec DOUBLE,
          image_Url TEXT,
          image_Blob BLOB,
          info TEXT,
          reportingRate DOUBLE,
          totalRecords INTEGER
          )''');
    await db.execute('''
          CREATE TABLE provinces(
            id INTEGER PRIMARY KEY,
            easterncape NUMERIC,
            gauteng NUMERIC,
            kwazulunatal NUMERIC,
            limpopo NUMERIC,
            mpumalanga NUMERIC,
            northerncape NUMERIC,
            northwest NUMERIC,
            westerncape NUMERIC,
            freestate NUMERIC
          )''');
  }

  Future<void> insertBird(Bird bird) async {
    final db = await instance.database;
    if (!await isDuplicate(bird)) {
      await db
          .insert(
        'birds',
        bird.toMapLIfe(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      )
          .then((value) {
        print('inserted $value + $bird');
      });
    }
  }

  Future<List<Bird>> fetchLifeList() async {
    final db = await instance.database;

    final List<Map<String, Object?>> birdMap = await db.query(
      'birds',
      orderBy: 'commonGroup DESC, commonSpecies DESC',
    );
    return birdMap.map(
      (map) {
        return Bird(
          id: map['id'] as int,
          commonGroup:
              map['commonGroup'] != null ? map['commonGroup'] as String : '',
          commonSpecies: map['commonSpecies'] != null
              ? map['commonSpecies'] as String
              : '',
          fullProtocolRR: 0.0,
          fullProtocolNumber: 0,
          latestFP: map['latestFP'] != null ? map['latestFP'] as String : '',
          reportingRate: map['reportingRate'] != null
              ? map['reportingRate'] as double
              : 0.0,
          genus: map['genus'] as String,
          species: map['species'] as String,
          pentad: Pentad(
            pentadAllocation: map['pentad'].toString(),
            pentadLongitude: 0.0,
            pentadLatitude: 0.0,
            province: Province(
              id: 0,
              name: ' ',
            ),
            totalCards: 0,
          ),
          jan: 0.0,
          feb: 0.0,
          mar: 0.0,
          apr: 0.0,
          may: 0.0,
          jun: 0.0,
          jul: 0.0,
          aug: 0.0,
          sep: 0.0,
          oct: 0.0,
          nov: 0.0,
          dec: 0.0,
          totalRecords: 0,
        );
      },
    ).toList();
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

  Future<void> initialInsert(List<Bird> allBirds) async {
    final db = await instance.database;
    if (await containsData() == 0) {
      final batch = db.batch();
      for (Bird bird in allBirds) {
        batch.insert('allBirds', bird.toAllBirdsMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit();
      // allBirds.map((bird) => insertIntoAll(db, bird));
    }
  }

  Future<int> containsData() async {
    final db = await instance.database;
    final int count = Sqflite.firstIntValue(
          await db.query(
            'allBirds',
            columns: ['COUNT(*)'],
          ),
        ) ??
        0;
    print(count);
    return count;
  }
}
