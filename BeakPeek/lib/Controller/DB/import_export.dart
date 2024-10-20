import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Styles/colors.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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

  Future<void> exportLifeList(BuildContext context) async {
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

    // Show confirmation
    _showExportSuccessDialog(context);
  }

  void _showExportSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.popupColor(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          contentPadding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 24.0), // Add more padding for better spacing
          title: Center(
            child: Text(
              'Export Successful',
              style: GlobalStyles.smallHeadingPrimary(context),
              textAlign: TextAlign.center, // Align title to center
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: AppColors.tertiaryColor(context),
                size: 50.0,
              ),
              const SizedBox(height: 20),
              Text(
                'Your Life List has been exported to your downloads folder.',
                style: GlobalStyles.contentPrimary(context),
                textAlign: TextAlign.center, // Align message text to center
              ),
            ],
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 30.0),
                  backgroundColor: AppColors.tertiaryColor(context),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: Color.fromARGB(255, 27, 27, 27),
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> importLifeList() async {
    await Permission.storage.request();
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
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
