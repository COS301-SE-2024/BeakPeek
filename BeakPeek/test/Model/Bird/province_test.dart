import 'package:flutter_test/flutter_test.dart';
import 'package:beakpeek/Model/BirdInfo/province.dart';

void main() {
  group('Province class unit tests', () {
    test('fromJson constructor with valid data', () {
      final provinceData = {
        'id': 1,
        'name': 'Gauteng',
        'birds': ['bird1', 'bird2']
      };

      final province = Province.fromJson(provinceData);

      expect(province.id, 1);
      expect(province.name, 'Gauteng');
      expect(province.birds, ['bird1', 'bird2']);
    });

    test('toMap method', () {
      final province =
          Province(id: 2, name: 'Western Cape', birds: ['bird3', 'bird4']);

      final map = province.toMap();

      expect(map['id'], 2);
      expect(map['name'], 'Western Cape');
      expect(map['birds'], ['bird3', 'bird4']);
    });
  });
}
