import 'package:beakpeek/Controller/Home/search.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Create a mock class for the rootBundle
class MockAssetBundle extends Mock implements AssetBundle {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Bird Info Tests', () {
    final mockAssetBundle = MockAssetBundle();

    setUp(() {
      // Replace the rootBundle with the mock before each test
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('flutter/services'),
        (methodCall) async {
          if (methodCall.method == 'rootBundle.loadString') {
            return Future.value('''
            [
              {"commonGroup": "Sparrow", "commonSpecies": "Passeridae"},
              {"commonGroup": "Eagle", "commonSpecies": "Accipitridae"}
            ]
            ''');
          }
          throw Exception('Method not found');
        },
      );
    });

    tearDown(() {
      // Clear any mocks after each test
      reset(mockAssetBundle);
    });

    test('loadJsonFromAssets returns decoded JSON data', () async {
      // Act
      final result = await loadJsonFromAssets();

      // Assert
      expect(result, isA<List<dynamic>>());
      expect(result.length, 867); // Check if two birds are loaded
    });

    test('listBirdFromAssets returns a list of Bird objects', () async {
      // Act
      final result = await listBirdFromAssets();

      // Assert
      expect(result, isA<List<Bird>>());
      expect(result.length, 867); // Check if two Bird objects are created
      // Check the name of the first Bird object
    });
  });
}
