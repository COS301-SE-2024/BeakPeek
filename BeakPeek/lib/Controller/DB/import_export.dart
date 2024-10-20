import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
// ignore: unused_import
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class ImportExport {
  List<String> header = [
    'ref',
    'common_group',
    'common_species',
    'genus',
    'species'
  ];

  Future<String> getExternalDocumentPath() async {
    // To check whether permission is given for this app or not.
    Directory directory = Directory('');
    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      directory = Directory('/storage/emulated/0/Download');
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final exPath = directory.path;
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  Future<String> get _localPath async {
    // final directory = await getApplicationDocumentsDirectory();
    // return directory.path;
    // To get the external path from device of download folder
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  Future<File> createTextFile(String fileName, String content) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(content);
    return file;
  }

  Future<void> exportLifeList() async {
    final path = await _localPath;
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

    final File file = File('$path/lifelist.csv');

    // Write the data in the file you have created
    file.writeAsString(csv);
  }

  Future<void> importLifeList() async {
    await Permission.storage.request();
    final FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final File file = File(result.files.single.path!);
      handleFile(file);
    }
  }

  Future<void> handleFile(File file) async {
    late final LifeListProvider lifeList = LifeListProvider.instance;
    final List<List<String>> listOfLists = [];
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
