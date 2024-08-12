import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:perfect_corp_homework/native/features/download/data/backend_service/util/uuid.dart';

class FileUtil {
  /// private constructor for util class
  FileUtil._();

  /// move the file to [newPath] and delete the [sourceFile]
  static Future<File> moveFile(File sourceFile, String newPath) async {
    try {
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
    return uuid.v4();
  }

  static Future<String> generatePersistThumbnailName(
      {required String filename, required String fileType}) async {
    String persistAbsolute =
        '${(await getApplicationDocumentsDirectory()).path}/thumbnails/$filename.$fileType';
    return persistAbsolute;
  }

  static Future<String> generatePersistFileName(
      {required String filename, required String fileType}) async {
    String persistAbsolute =
        '${(await getApplicationDocumentsDirectory()).path}/$filename.$fileType';
    return persistAbsolute;
  }

  static Future<String> generateTemporaryFileName(
      {required String filename, required String fileType}) async {
    String temporaryAbsolute =
        '${(await getTemporaryDirectory()).path}/$filename.$fileType';
    return temporaryAbsolute;
  }
}
