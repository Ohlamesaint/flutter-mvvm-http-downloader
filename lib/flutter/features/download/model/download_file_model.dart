import 'package:path_provider/path_provider.dart';

class DownloadFileModel {
  String filename;
  String fileType;

  DownloadFileModel({required this.filename, required this.fileType});

  Future<String> generatePersistThumbnailName() async {
    String persistAbsolute =
        '${(await getApplicationDocumentsDirectory()).path}/thumbnails/$filename.$fileType';
    return persistAbsolute;
  }

  Future<String> generatePersistFileName() async {
    String persistAbsolute =
        '${(await getApplicationDocumentsDirectory()).path}/$filename.$fileType';
    return persistAbsolute;
  }

  Future<String> generateTemporaryFileName() async {
    String temporaryAbsolute =
        '${(await getTemporaryDirectory()).path}/$filename.$fileType';
    return temporaryAbsolute;
  }
}
