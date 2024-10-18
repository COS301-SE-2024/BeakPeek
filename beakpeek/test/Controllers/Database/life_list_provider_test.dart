// ignore_for_file: unused_local_variable

import 'package:beakpeek/Model/BirdInfo/pentad.dart';
import 'package:beakpeek/Model/BirdInfo/province.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'life_list_provider_test.mocks.dart';

void sqfliteTestInit() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}

@GenerateMocks([Database])
void main() {
  late LifeListProvider lifeListProvider;
  late MockDatabase mockDatabase;
  late Bird testBird;
  setUp(
    () {
      mockDatabase = MockDatabase();
      lifeListProvider = LifeListProvider.instance;
      LifeListProvider.lifeList = mockDatabase;
      final province = Province(id: 1, name: 'Province A');
      final pentad = Pentad(
        pentadAllocation: 'Allocation A',
        pentadLongitude: 20.0,
        pentadLatitude: 30.0,
        province: province,
        totalCards: 50,
      );
      testBird = Bird(
        id: 1,
        pentad: pentad,
        commonGroup: 'Group A',
        commonSpecies: 'Species A',
        genus: 'Genus A',
        species: 'Species A',
        fullProtocolRR: 10.0,
        fullProtocolNumber: 5,
        latestFP: 'FP A',
        jan: 1.0,
        feb: 2.0,
        mar: 3.0,
        apr: 4.0,
        may: 5.0,
        jun: 6.0,
        jul: 7.0,
        aug: 8.0,
        sep: 9.0,
        oct: 10.0,
        nov: 11.0,
        dec: 12.0,
        totalRecords: 100,
        reportingRate: 50.0,
      );
    },
  );

  tearDown(
    () async {
      await lifeListProvider.close();
    },
  );

  group(
    'LifeListProvider Tests',
    () {
      test(
        'Fetch Life List',
        () async {
          when(
            mockDatabase.query(
              'birds',
              orderBy: anyNamed('orderBy'),
            ),
          ).thenAnswer((_) async => [testBird.toMap()]);

          final birds = await lifeListProvider.fetchLifeList();

          expect(birds, isA<List<Bird>>());
          expect(birds.length, 1);
          expect(birds.first.commonSpecies, 'Species A');
        },
      );

      test(
        'Delete Bird',
        () async {
          when(
            mockDatabase.delete(
              'birds',
              where: anyNamed('where'),
              whereArgs: anyNamed('whereArgs'),
            ),
          ).thenAnswer((_) async => 1);

          await lifeListProvider.delete(testBird);

          verify(
            mockDatabase.delete(
              'birds',
              where: anyNamed('where'),
              whereArgs: anyNamed('whereArgs'),
            ),
          ).called(1);
        },
      );

      test(
        'Is Duplicate - True',
        () async {
          when(
            mockDatabase.query(
              'birds',
              columns: anyNamed('columns'),
              where: anyNamed('where'),
              whereArgs: anyNamed('whereArgs'),
            ),
          ).thenAnswer((_) async => [testBird.toMap()]);

          final isDuplicate = await lifeListProvider.isDuplicate(testBird);

          expect(isDuplicate, true);
        },
      );

      test(
        'Is Duplicate - False',
        () async {
          when(
            mockDatabase.query(
              'birds',
              columns: anyNamed('columns'),
              where: anyNamed('where'),
              whereArgs: anyNamed('whereArgs'),
            ),
          ).thenAnswer((_) async => []);

          final isDuplicate = await lifeListProvider.isDuplicate(testBird);

          expect(isDuplicate, false);
        },
      );
    },
  );
}
