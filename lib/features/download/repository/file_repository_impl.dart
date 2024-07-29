import 'dart:io';

import 'package:perfect_corp_homework/features/download/model/download_file_model.dart';
import 'package:perfect_corp_homework/features/download/repository/file_repository.dart';

import '../../../util/file_util.dart';

class FileRepositoryImpl implements FileRepository {
  @override
  void persistFile(DownloadFileModel downloadFileModel) async {
    String documentAbsolute = await downloadFileModel.generatePersistFileName();
    String documentThumbnailAbsolute =
        await downloadFileModel.generatePersistThumbnailName();
    File tempFile = File(await downloadFileModel.generateTemporaryFileName());
    var persistFile = await FileUtil.moveFile(tempFile, documentAbsolute);
    // compress the image as thumbnail
    await FileUtil.compressFile(persistFile, documentThumbnailAbsolute);
  }
}
