// ignore_for_file: unused_local_variable

import 'package:flutter_test/flutter_test.dart';
import 'package:beakpeek/Model/bird.dart';
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
      testBird = Bird(
        pentad: '12345',
        spp: 1,
        commonGroup: 'Group',
        commonSpecies: 'Species',
        genus: 'Genus',
        species: 'Species',
        reportingRate: 0.5,
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
        'Insert Bird - Not Duplicate',
        () async {
          when(
            mockDatabase.query(
              'birds',
              columns: anyNamed('columns'),
              where: anyNamed('where'),
              whereArgs: anyNamed('whereArgs'),
            ),
          ).thenAnswer((_) async => []);

          when(
            mockDatabase.insert(
              'birds',
              testBird.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            ),
          ).thenAnswer((_) async => 1);

          await lifeListProvider.insertBird(testBird);

          verify(
            mockDatabase.insert(
              'birds',
              testBird.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            ),
          ).called(1);
        },
      );

      test(
        'Insert Bird - Duplicate',
        () async {
          when(
            mockDatabase.query(
              'birds',
              columns: anyNamed('columns'),
              where: anyNamed('where'),
              whereArgs: anyNamed('whereArgs'),
            ),
          ).thenAnswer((_) async => [testBird.toMap()]);

          await lifeListProvider.insertBird(testBird);

          verifyNever(
            mockDatabase.insert(
              'birds',
              testBird.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            ),
          );
        },
      );

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
          expect(birds.first.commonSpecies, 'Species');
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
