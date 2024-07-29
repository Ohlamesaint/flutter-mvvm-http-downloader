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
}
