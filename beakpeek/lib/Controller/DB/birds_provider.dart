// ignore_for_file: avoid_print

import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Model/BirdInfo/pentad.dart';
import 'package:beakpeek/Model/BirdInfo/province.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BirdsProvider {
  BirdsProvider._internal();
  static final BirdsProvider instance = BirdsProvider._internal();

  static Database? allBirds;

  Future<Database> get database async {
    if (allBirds != null) {
      return allBirds!;
    }

    allBirds = await _initDatabase();
    return allBirds!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'life_list.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE allBirds(
          id INTEGER PRIMARY KEY, 
          commonGroup TEXT, 
          commonSpecies TEXT, 
          genus TEXT, 
          species TEXT,
          full_Protocol_RR REAL,
          full_Protocol_Number INTEGER,
          latest_FP NUMERIC,
          image_Url TEXT,
          image_Blob BLOB,
          info TEXT,
          reportingRate DOUBLE
          )
          
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
          )''',
        );
      },
    );
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

  Future<List<Bird>> fetchBirds() async {
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
}
