import 'dart:async';
import 'dart:convert';

import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Model/BirdInfo/province_data.dart';
import 'package:beakpeek/Model/UserProfile/user_model.dart';
import 'package:beakpeek/config_azure.dart';
import 'package:http/http.dart';
import 'package:localstorage/localstorage.dart';
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
    // ignore: avoid_print
    print('Database deleted');
  }

  Future _createDb(Database db, version) async {
    await db.execute('''CREATE TABLE birds(
          id INTEGER PRIMARY KEY, 
          commonGroup TEXT, 
          commonSpecies TEXT, 
          genus TEXT, 
          species TEXT, 
          reportingRate DOUBLE,
          image_Url Text,
          image_Blob BLOB
          
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
          totalRecords INTEGER,
          birdPopulation INTEGER
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

  Future<List<int>> getNumBirdsInProvinces() async {
    final db = await instance.database;
    final List<int> count = [];
    const List<String> provinces = [
      'easterncape',
      'gauteng',
      'kwazulunatal',
      'limpopo',
      'mpumalanga',
      'northerncape',
      'northwest',
      'westerncape',
      'freestate',
    ];

    for (final prov in provinces) {
      final int temp = Sqflite.firstIntValue(
            await db.query('provinces',
                columns: ['COUNT(*)'], where: '$prov = true'),
          ) ??
          0;
      count.add(temp);
    }
    return count;
  }

  Future<List<double>> precentLifeListBirds() async {
    final db = await instance.database;
    final List<int> allBirds = await getNumBirdsInProvinces();
    final List<Bird> life = await fetchLifeList();
    const List<String> provinces = [
      'easterncape',
      'gauteng',
      'kwazulunatal',
      'limpopo',
      'mpumalanga',
      'northerncape',
      'northwest',
      'westerncape',
      'freestate',
    ];
    final List<double> count = [0, 0, 0, 0, 0, 0, 0, 0, 0];
    for (Bird tempB in life) {
      final int ref = tempB.getId();
      int i = 0;
      for (String prov in provinces) {
        final int temp = Sqflite.firstIntValue(
              await db.query('provinces',
                  columns: [prov], where: '$prov = true AND id = $ref'),
            ) ??
            0;
        if (temp != 0) {
          count[i] += 1.0;
        }
        i++;
      }
      i = 0;
    }
    for (int i = 0; i < provinces.length; i++) {
      if (count[i] != 0) {
        count[i] = (count[i] / allBirds[i]);
      }
    }
    return count;
  }

  Future<void> insertBird(int birdId) async {
    final bird = await getBirdInByID(birdId);
    switch (bird.commonGroup.toLowerCase()) {
      case 'weaver':
        updateProgress(bird.commonGroup, 'Weaver Believer');
        break;
      case 'duck':
        updateProgress(bird.commonGroup, 'Duck Hunter');
        break;
      case 'eagle':
        updateProgress(bird.commonGroup, 'USA');
        break;
      case 'kingfisher':
        updateProgress(bird.commonGroup, 'Fisherman');
        break;
      case 'hawk':
        updateProgress(bird.commonGroup, 'Hawk Spotter');
        break;
      case 'heron':
        updateProgress(bird.commonGroup, 'Heron Horror');
        break;
    }
    //await updateLifeListAchievments(bird.commonGroup, birdId);
    final db = await instance.database;
    if (!await isDuplicate(bird)) {
      await db
          .insert(
        'birds',
        bird.toMapLIfe(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      )
          .then(
        (value) {
          // ignore: avoid_print
          print('inserted $value + $bird');
        },
      );
    }
  }

  Future<String> updateUserLifelist() async {
    final db = await instance.database;
    final List<Map<String, Object?>> birdMap = await db.query(
      'birds',
      orderBy: 'commonGroup DESC',
      columns: ['id'],
    );
    final String encodedString = jsonEncode(birdMap);
    user.lifelist = encodedString;
    storeUserLocally(user);
    return encodedString;
  }

  Future<String> fetchUserLifelistString() async {
    final db = await instance.database;
    final List<Map<String, Object?>> birdMap = await db.query(
      'birds',
      orderBy: 'commonGroup DESC',
      columns: ['id'],
    );
    final String encodedString = jsonEncode(birdMap);
    // user.lifelist = encodedString;
    // storeUserLocally(user);
    return encodedString;
  }

  Future<List<Bird>> fetchLifeList() async {
    final db = await instance.database;

    final List<Map<String, Object?>> birdMap = await db.query(
      'birds',
      orderBy: 'commonGroup DESC',
    );
    return birdMap.map(
      (map) {
        return Bird.fromJsonLifeList(map);
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
    final batch = db.batch();
    if (await containsData() == 0) {
      for (Bird temp in allBirds) {
        if (temp.reportingRate >= 0.1) {
          batch.insert('allBirds', temp.toAllBirdsMap(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
      batch.commit();
    }
  }

  Future<void> initialProvInsert(List<Bird> allBirds) async {
    final db = await instance.database;
    if (await containsProvData() == 0) {
      final batchProv = db.batch();
      for (Bird bird in allBirds) {
        if (bird.reportingRate >= 1) {
          batchProv.insert('provinces', bird.toMapProvince(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
      await batchProv.commit();
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
    return count;
  }

  Future<int> allBirdCount(String commonGroup) async {
    final db = await instance.database;
    final int count = Sqflite.firstIntValue(
          await db.query('allBirds',
              columns: ['COUNT(*)'],
              where: 'commonGroup = ?',
              whereArgs: [commonGroup]),
        ) ??
        0;
    return count;
  }

  Future<void> updateProgress(String commonGroup, String achievmentName) async {
    final int countBird = await lifeBirdCount(commonGroup);
    final int totalBird = await allBirdCount(commonGroup);
    double progress = countBird / totalBird;
    progress = progress < 1 ? progress : 1;
    localStorage.setItem(achievmentName, progress.toString());
    updateProvinces();
  }

  Future<void> updateProvinces() async {
    final List<String> achivementNamesProvinces = [
      'Risk it for the Biscuits',
      'Gauteng Explorer',
      'Watch The Waves',
      'Limpopo Hoopoe',
      'Mpumalanga Adventurer',
      'Diamond Hunter',
      'Directionally challenged',
      'Western Cape Wanderer',
      'Freesest Alive'
    ];
    final List<double> progress = await precentLifeListBirds();
    for (int i = 0; i < achivementNamesProvinces.length; i++) {
      localStorage.setItem(achivementNamesProvinces[i], progress.toString());
    }
  }

  Future<int> lifeBirdCount(String commonGroup) async {
    final db = await instance.database;
    final int count = Sqflite.firstIntValue(
          await db.query('birds',
              columns: ['COUNT(*)'],
              where: 'commonGroup = ?',
              whereArgs: [commonGroup]),
        ) ??
        0;
    return count;
  }

  Future<int> containsProvData() async {
    final db = await instance.database;
    final int count = Sqflite.firstIntValue(
          await db.query(
            'provinces',
            columns: ['COUNT(*)'],
          ),
        ) ??
        0;
    return count;
  }

  Future<ProvinceData> getBirdProvinces(int id) async {
    final db = await instance.database;
    late ProvinceData prov;
    await db.query(
      'provinces',
      where: 'id =?',
      whereArgs: [id],
    ).then((result) {
      prov = ProvinceData.fromJson(result.first);
    });
    return prov;
  }

  Future<List<Bird>> getFullBirdData() async {
    final db = await instance.database;

    final List<Map<String, Object?>> birdMap = await db.query(
      'allBirds',
    );
    return birdMap.map(
      (map) {
        //image conversion and
        return Bird(
          id: map['id'] as int,
          commonGroup:
              map['commonGroup'] != null ? map['commonGroup'] as String : '',
          commonSpecies: map['commonSpecies'] != null
              ? map['commonSpecies'] as String
              : '',
          fullProtocolRR: map['fullProtocolRR'] as double,
          fullProtocolNumber: map['fullProtocolNumber'] as int,
          latestFP: map['latestFP'] != null ? map['latestFP'] as String : '',
          reportingRate: map['reportingRate'] != null
              ? map['reportingRate'] as double
              : 0.0,
          genus: map['genus'] as String,
          species: map['species'] as String,
          jan: map['jan'] as double,
          feb: map['feb'] as double,
          mar: map['mar'] as double,
          apr: map['apr'] as double,
          may: map['may'] as double,
          jun: map['jun'] as double,
          jul: map['jul'] as double,
          aug: map['aug'] as double,
          sep: map['sep'] as double,
          oct: map['oct'] as double,
          nov: map['nov'] as double,
          dec: map['dec'] as double,
          totalRecords: map['totalRecords'] as int,
          imageUrl: map['image_Url'] as String,
          population: map['birdPopulation'] as int,
        );
      },
    ).toList();
  }

  Future<Bird> getBirdInByID(int id) async {
    final db = await instance.database;
    final List<Map<String, Object?>> map =
        await db.query('allBirds', where: 'id = ?', whereArgs: [id]);
    final Bird temp = Bird(
      id: map[0]['id'] as int,
      commonGroup:
          map[0]['commonGroup'] != null ? map[0]['commonGroup'] as String : '',
      commonSpecies: map[0]['commonSpecies'] != null
          ? map[0]['commonSpecies'] as String
          : '',
      fullProtocolRR: map[0]['fullProtocolRR'] as double,
      fullProtocolNumber: map[0]['fullProtocolNumber'] as int,
      latestFP: map[0]['latestFP'] != null ? map[0]['latestFP'] as String : '',
      reportingRate: map[0]['reportingRate'] != null
          ? map[0]['reportingRate'] as double
          : 0.0,
      genus: map[0]['genus'] as String,
      species: map[0]['species'] as String,
      jan: map[0]['jan'] as double,
      feb: map[0]['feb'] as double,
      mar: map[0]['mar'] as double,
      apr: map[0]['apr'] as double,
      may: map[0]['may'] as double,
      jun: map[0]['jun'] as double,
      jul: map[0]['jul'] as double,
      aug: map[0]['aug'] as double,
      sep: map[0]['sep'] as double,
      oct: map[0]['oct'] as double,
      nov: map[0]['nov'] as double,
      dec: map[0]['dec'] as double,
      totalRecords: map[0]['totalRecords'] as int,
      imageUrl: map[0]['image_Url'] as String,
      info: map[0]['info'] as String,
      population: map[0]['birdPopulation'] as int,
    );
    return temp;
  }

  Future<Bird> getBirdInfoByID(int id) async {
    final db = await instance.database;
    final List<Map<String, Object?>> birdMap =
        await db.query('allBirds', where: 'id = ?', whereArgs: [id]);
    return Bird.fromJsonLife(birdMap[0]);
  }

  Future<void> addImage(int id, String img) async {
    final db = await instance.database;
    final image = await get(Uri.parse(img));
    final bytes = image.bodyBytes.toString();
    await db.rawUpdate(
      '''UPDATE allBirds
      SET image_Blob = ?
      WHERE id = ?''',
      [bytes, id],
    );

    await db.rawUpdate(
      '''UPDATE birds
      SET image_Blob = ?
      WHERE id = ?''',
      [bytes, id],
    );
  }

  Future<List<Map<String, Object?>>> getLifeListForUser() async {
    final db = await instance.database;
    return await db.query('birds');
  }

  Future<String> getImage(int id) async {
    final db = await instance.database;
    final List<Map<String, Object?>> birdMap = await db.query(
      'allBirds',
      columns: ['image_Blob'],
      where: 'id = ?',
      whereArgs: [id],
    );
    return birdMap[0]['image_Blob'] as String;
  }
}
