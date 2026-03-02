import 'dart:io' show File;
import 'package:path_provider/path_provider.dart';

Future<String> savePdfBytesToFile(List<int> bytes, String filename) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$filename');
  await file.writeAsBytes(bytes);
  return file.path;
}

Future<String> saveCsvToFile(String contents, String filename) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$filename');
  await file.writeAsString(contents);
  return file.path;
}
