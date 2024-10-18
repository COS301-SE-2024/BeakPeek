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
    () async {
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
      test('returns a list of Bird objects from database', () async {
        // Arrange
        final mockBirdData = [
          {
            'id': 1,
            'commonGroup': 'Weaver',
            'commonSpecies': 'Weaver Bird',
            'fullProtocolRR': 0.85,
            'fullProtocolNumber': 150,
            'latestFP': '2024-10-18',
            'reportingRate': 0.75,
            'genus': 'Ploceus',
            'species': 'Ploceus velatus',
            'jan': 0.1,
            'feb': 0.2,
            'mar': 0.3,
            'apr': 0.4,
            'may': 0.5,
            'jun': 0.6,
            'jul': 0.7,
            'aug': 0.8,
            'sep': 0.9,
            'oct': 1.0,
            'nov': 1.1,
            'dec': 1.2,
            'totalRecords': 1000,
            'image_Url': 'https://example.com/image.png',
            'birdPopulation': 500,
          },
          // Add more mock bird data if necessary
        ];

        when(mockDatabase.query('allBirds'))
            .thenAnswer((_) async => mockBirdData);

        // Act
        final result = await lifeListProvider.getFullBirdData();

        // Assert
        expect(result, isA<List<Bird>>());
        expect(result.length, 1);
        expect(result[0].id, 1);
        expect(result[0].commonGroup, 'Weaver');
        expect(result[0].commonSpecies, 'Weaver Bird');
        expect(result[0].fullProtocolRR, 0.85);
        expect(result[0].totalRecords, 1000);
        expect(result[0].imageUrl, 'https://example.com/image.png');
      });

      test('returns a Bird object when bird with specific ID is found',
          () async {
        // Arrange
        final mockBirdData = [
          {
            'id': 1,
            'commonGroup': 'Weaver',
            'commonSpecies': 'Weaver Bird',
            'fullProtocolRR': 0.85,
            'fullProtocolNumber': 150,
            'latestFP': '2024-10-18',
            'reportingRate': 0.75,
            'genus': 'Ploceus',
            'species': 'Ploceus velatus',
            'jan': 0.1,
            'feb': 0.2,
            'mar': 0.3,
            'apr': 0.4,
            'may': 0.5,
            'jun': 0.6,
            'jul': 0.7,
            'aug': 0.8,
            'sep': 0.9,
            'oct': 1.0,
            'nov': 1.1,
            'dec': 1.2,
            'totalRecords': 1000,
            'image_Url': 'https://example.com/image.png',
            'info': 'Bird information',
            'birdPopulation': 500,
          }
        ];

        when(mockDatabase.query(
          'allBirds',
          where: 'id = ?',
          whereArgs: [1],
        )).thenAnswer((_) async => mockBirdData);

        // Act
        final result = await lifeListProvider.getBirdInByID(1);

        // Assert
        expect(result, isA<Bird>());
        expect(result.id, 1);
        expect(result.commonGroup, 'Weaver');
        expect(result.commonSpecies, 'Weaver Bird');
        expect(result.fullProtocolRR, 0.85);
        expect(result.totalRecords, 1000);
        expect(result.imageUrl, 'https://example.com/image.png');
        expect(result.info, 'Bird information');
      });
      test(
        'Insert Bird LifeList',
        () async {
          when(
            mockDatabase.query(
              'allBirds',
              where: 'id = ${testBird.id}',
            ),
          ).thenAnswer((_) async => [testBird.toMap()]);
          when(
            mockDatabase.query(
              'provinces',
              columns: ['COUNT(*)'],
              where: 'easterncape = true',
            ),
          ).thenAnswer((_) async => [
                {'COUNT(*)': 5}
              ]);
          when(
            mockDatabase.query(
              'provinces',
              columns: ['COUNT(*)'],
              where: 'gauteng = true',
            ),
          ).thenAnswer((_) async => [
                {'COUNT(*)': 5}
              ]);
          when(
            mockDatabase.query(
              'provinces',
              columns: ['COUNT(*)'],
              where: 'kwazulunatal = true',
            ),
          ).thenAnswer((_) async => [
                {'COUNT(*)': 5}
              ]);
          when(
            mockDatabase.query(
              'provinces',
              columns: ['COUNT(*)'],
              where: 'limpopo = true',
            ),
          ).thenAnswer((_) async => [
                {'COUNT(*)': 5}
              ]);
          when(
            mockDatabase.insert(
              'birds',
              testBird.toMapLIfe(),
            ),
          ).thenAnswer((_) async => 1);

          verifyNever(mockDatabase.query(
            'birds',
            where: 'id = ?',
            whereArgs: [testBird.id],
          ));
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
  group(
    'LifeListProvider Calculation Tests',
    () {
      test(
        'GetNumBirdsInProvinces',
        () async {
          when(
            mockDatabase.query(
              'provinces',
              columns: ['COUNT(*)'],
              where: 'easterncape = true',
            ),
          ).thenAnswer((_) async => [
                {'COUNT(*)': 5}
              ]);
          when(
            mockDatabase.query(
              'provinces',
              columns: ['COUNT(*)'],
              where: 'gauteng = true',
            ),
          ).thenAnswer((_) async => [
                {'COUNT(*)': 5}
              ]);
          when(
            mockDatabase.query(
              'provinces',
              columns: ['COUNT(*)'],
              where: 'kwazulunatal = true',
            ),
          ).thenAnswer((_) async => [
                {'COUNT(*)': 5}
              ]);
          when(
            mockDatabase.query(
              'provinces',
              columns: ['COUNT(*)'],
              where: 'limpopo = true',
            ),
          ).thenAnswer((_) async => [
                {'COUNT(*)': 5}
              ]);
          when(
            mockDatabase.query(
              'provinces',
              columns: ['COUNT(*)'],
              where: 'mpumalanga = true',
            ),
          ).thenAnswer((_) async => [
                {'COUNT(*)': 5}
              ]);
          when(
            mockDatabase.query(
              'provinces',
              columns: ['COUNT(*)'],
              where: 'northerncape = true',
            ),
          ).thenAnswer((_) async => [
                {'COUNT(*)': 5}
              ]);

          when(
            mockDatabase.query(
              'provinces',
              columns: ['COUNT(*)'],
              where: 'northwest = true',
            ),
          ).thenAnswer((_) async => [
                {'COUNT(*)': 5}
              ]);
          when(
            mockDatabase.query(
              'provinces',
              columns: ['COUNT(*)'],
              where: 'westerncape = true',
            ),
          ).thenAnswer((_) async => [
                {'COUNT(*)': 5}
              ]);

          when(
            mockDatabase.query(
              'provinces',
              columns: ['COUNT(*)'],
              where: 'freestate = true',
            ),
          ).thenAnswer((_) async => [
                {'COUNT(*)': 5}
              ]);
          final isDuplicate = await lifeListProvider.getNumBirdsInProvinces();

          expect(isDuplicate[0], 5);
          expect(isDuplicate[1], 5);
          expect(isDuplicate[2], 5);
          expect(isDuplicate[3], 5);
          expect(isDuplicate[4], 5);
          expect(isDuplicate[5], 5);
          expect(isDuplicate[6], 5);
          expect(isDuplicate[7], 5);
          expect(isDuplicate[8], 5);
        },
      );

      test('precentLifeListBirds', () async {
        when(
          mockDatabase.query(
            'provinces',
            columns: ['COUNT(*)'],
            where: 'easterncape = true',
          ),
        ).thenAnswer((_) async => [
              {'COUNT(*)': 5}
            ]);
        when(
          mockDatabase.query(
            'provinces',
            columns: ['COUNT(*)'],
            where: 'gauteng = true',
          ),
        ).thenAnswer((_) async => [
              {'COUNT(*)': 5}
            ]);
        when(
          mockDatabase.query(
            'provinces',
            columns: ['COUNT(*)'],
            where: 'kwazulunatal = true',
          ),
        ).thenAnswer((_) async => [
              {'COUNT(*)': 5}
            ]);
        when(
          mockDatabase.query(
            'provinces',
            columns: ['COUNT(*)'],
            where: 'limpopo = true',
          ),
        ).thenAnswer((_) async => [
              {'COUNT(*)': 5}
            ]);
        when(
          mockDatabase.query(
            'provinces',
            columns: ['COUNT(*)'],
            where: 'mpumalanga = true',
          ),
        ).thenAnswer((_) async => [
              {'COUNT(*)': 5}
            ]);
        when(
          mockDatabase.query(
            'provinces',
            columns: ['COUNT(*)'],
            where: 'northerncape = true',
          ),
        ).thenAnswer((_) async => [
              {'COUNT(*)': 5}
            ]);

        when(
          mockDatabase.query(
            'provinces',
            columns: ['COUNT(*)'],
            where: 'northwest = true',
          ),
        ).thenAnswer((_) async => [
              {'COUNT(*)': 5}
            ]);
        when(
          mockDatabase.query(
            'provinces',
            columns: ['COUNT(*)'],
            where: 'westerncape = true',
          ),
        ).thenAnswer((_) async => [
              {'COUNT(*)': 5}
            ]);
        when(
          mockDatabase.query(
            'provinces',
            columns: ['COUNT(*)'],
            where: 'freestate = true',
          ),
        ).thenAnswer((_) async => [
              {'COUNT(*)': 5}
            ]);
        when(
          mockDatabase.query(
            'birds',
            orderBy: anyNamed('orderBy'),
          ),
        ).thenAnswer((_) async => [testBird.toMap()]);
        when(
          mockDatabase.query(
            'provinces',
            columns: ['easterncape'],
            where: 'easterncape = true AND id = ${testBird.id}',
          ),
        ).thenAnswer((_) async => [
              {'easterncape': 1}
            ]);
        when(
          mockDatabase.query(
            'provinces',
            columns: ['gauteng'],
            where: 'gauteng = true AND id = ${testBird.id}',
          ),
        ).thenAnswer((_) async => [
              {'gauteng': 1}
            ]);
        when(
          mockDatabase.query(
            'provinces',
            columns: ['kwazulunatal'],
            where: 'kwazulunatal = true AND id = ${testBird.id}',
          ),
        ).thenAnswer((_) async => [
              {'kwazulunatal': 1}
            ]);
        when(
          mockDatabase.query(
            'provinces',
            columns: ['limpopo'],
            where: 'limpopo = true AND id = ${testBird.id}',
          ),
        ).thenAnswer((_) async => [
              {'limpopo': 1}
            ]);
        when(
          mockDatabase.query(
            'provinces',
            columns: ['mpumalanga'],
            where: 'mpumalanga = true AND id = ${testBird.id}',
          ),
        ).thenAnswer((_) async => [
              {'mpumalanga': 5}
            ]);
        when(
          mockDatabase.query(
            'provinces',
            columns: ['northerncape'],
            where: 'northerncape = true AND id = ${testBird.id}',
          ),
        ).thenAnswer((_) async => [
              {'northerncape': 1}
            ]);

        when(
          mockDatabase.query(
            'provinces',
            columns: ['northwest'],
            where: 'northwest = true AND id = ${testBird.id}',
          ),
        ).thenAnswer((_) async => [
              {'northwest': 1}
            ]);
        when(
          mockDatabase.query(
            'provinces',
            columns: ['westerncape'],
            where: 'westerncape = true AND id = ${testBird.id}',
          ),
        ).thenAnswer((_) async => [
              {'westerncape': 1}
            ]);
        when(
          mockDatabase.query(
            'provinces',
            columns: ['freestate'],
            where: 'freestate = true AND id = ${testBird.id}',
          ),
        ).thenAnswer((_) async => [
              {'freestate': 1}
            ]);

        final progress = await lifeListProvider.precentLifeListBirds();

        expect(progress[0], 0.2);
      });

      test(
        'fetchUserLifelistString',
        () async {
          lifeListProvider = LifeListProvider.instance;
          when(
            mockDatabase.query(
              'birds',
              orderBy: 'commonGroup DESC',
              columns: ['id'],
            ),
          ).thenAnswer((_) async => [
                {'id': testBird.id}
              ]);
          final String temp = await lifeListProvider.fetchUserLifelistString();
          expect(temp, '[{"id":1}]');
        },
      );

      test(
        'containsData',
        () async {
          lifeListProvider = LifeListProvider.instance;
          when(
            mockDatabase.query(
              'allBirds',
              columns: ['COUNT(*)'],
            ),
          ).thenAnswer((_) async => [
                {'COUNT(*)': 0}
              ]);
          final int temp = await lifeListProvider.containsData();
          expect(temp, 0);
        },
      );
    },
  );
}
