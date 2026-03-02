// Stub for web: file system not available.
Future<String> savePdfBytesToFile(List<int> bytes, String filename) async {
  throw UnsupportedError('Saving PDF to file is not supported on web.');
}

Future<String> saveCsvToFile(String contents, String filename) async {
  throw UnsupportedError('Saving CSV to file is not supported on web.');
}
