import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class ImportExport {
  ImportExport() {
    header = [];
    header.add('ref');
    header.add('common_group');
    header.add('common_species');
    header.add('genus');
    header.add('species');
  }
  List<String> header = [];

  Future<void> exportLifeList() async {
    late final LifeListProvider lifeList = LifeListProvider.instance;
    final List<List<String>> listOfLists = [];
    final List<Bird> birdsLife = await lifeList.fetchLifeList();
    for (final bird in birdsLife) {
      listOfLists.add([
        bird.id.toString(),
        bird.commonGroup,
        bird.commonSpecies,
        bird.genus,
        bird.species,
      ]);
    }
    final String csv = const ListToCsvConverter().convert(listOfLists);
    final Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    // ignore: avoid_print
    print(statuses);
    if (await Permission.storage.isGranted) {
      final directory = await getApplicationDocumentsDirectory();
      // ignore: avoid_print
      print('dir $directory');
      final String file = '$directory';

      final File f = File('$file/lifelist.csv');

      f.writeAsString(csv);
    }
  }

  Future<void> importLifeList() async {
    late final LifeListProvider lifeList = LifeListProvider.instance;
    final List<List<String>> listOfLists = [];
    final FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowedExtensions: ['csv']);

    if (result != null) {
      final File file = File(result.files.single.path!);
      final contents = await file.readAsString();
      final List<List<String>> csvTable =
          const CsvToListConverter().convert(contents);
      // ignore: avoid_print
      print(csvTable.toString());
      for (final row in csvTable) {
        final bool inserted =
            await lifeList.insertBirdByGroupAndSpeciesImport(row[1], row[2]);
        if (!inserted) {
          listOfLists.add(row);
        }
      }
    }
  }
}
