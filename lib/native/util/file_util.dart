import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class FileUtil {
  /// private constructor for util class
  FileUtil._();

  /// move the file to [newPath] and delete the [sourceFile]
  static Future<File> moveFile(File sourceFile, String newPath) async {
    try {
      print(sourceFile.path);
      print(newPath);
      return await sourceFile.rename(newPath);
    } on FileSystemException {
      final newFile = await sourceFile.copy(newPath);
      await sourceFile.delete();
      return newFile;
    }
  }

  static Future<void> compressFile(File file, String outputPath) async {
    await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outputPath,
      quality: 50,
      minHeight: 500,
      minWidth: 500,
    );
  }

  static List<File> getAllFilesInDirectory(String path) {
    Directory dir = Directory(path);
    List<File> files = [];
    dir.listSync().whereType<File>().forEach(files.add);
    return files;
  }

  static String generateFileName() {
    return sha256.convert(utf8.encode(_getRandomString(20))).toString();
  }

  static String _getRandomString(int length) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  static Future<void> createFile(String path) async {
    await File(path).create();
    return;
  }

  static Future<String> generatePersistThumbnailName(
      {required String filename, required String fileType}) async {
    String persistAbsolute =
        '${(await getApplicationDocumentsDirectory()).path}/thumbnails/$filename.$fileType';
    return persistAbsolute;
  }

  static Future<String> getThumbnailImageDirectory() async {
    return '${(await getApplicationDocumentsDirectory()).path}/thumbnails/';
  }

  static Future<String> getPersistImageDirectory() async {
    return '${(await getApplicationDocumentsDirectory()).path}/images/';
  }

  static Future<String> generatePersistFileName(
      {required String filename, required String fileType}) async {
    String persistAbsolute =
        '${(await getApplicationDocumentsDirectory()).path}/images/$filename.$fileType';
    return persistAbsolute;
  }

  static Future<String> generateTemporaryFileName(
      {required String filename, required String fileType}) async {
    String temporaryAbsolute =
        '${(await getTemporaryDirectory()).path}/$filename.$fileType';
    return temporaryAbsolute;
  }
}
