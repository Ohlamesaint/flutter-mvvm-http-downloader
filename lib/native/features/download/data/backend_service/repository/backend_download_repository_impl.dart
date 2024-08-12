import 'package:http/http.dart' as http;
import 'package:perfect_corp_homework/native/features/download/data/backend_service/model/backend_file_entity.dart';
import 'package:perfect_corp_homework/native/features/download/data/backend_service/repository/backend_download_repository.dart';

import '../api/service_result.dart';
import '../model/backend_download_entity.dart';
import '../util/network_util.dart';
import '../util/file_util.dart';
import '../util/uuid.dart';
import '../api/app_exception.dart';

class BackendDownloadRepositoryImpl implements BackendDownloadRepository {
  Future<ServiceResult<BackendDownloadEntity>> fetchImageWithUrl(
      {required String urlString}) async {
    try {
      http.StreamedResponse response =
          await NetworkUtil.fetchStreamImageDataWithUrlString(urlString);

      // generate temporary file name
      String fileType = response.headers['content-type']!.split('/')[1];
      String filename = FileUtil.generateFileName();
      String thumbnailPath = await FileUtil.generatePersistThumbnailName(
          filename: filename, fileType: fileType);
      String imagePath = await FileUtil.generatePersistFileName(
          filename: filename, fileType: fileType);
      String temporaryImagePath = await FileUtil.generateTemporaryFileName(
          filename: filename, fileType: fileType);

      // initialize download entity with callback from download view model

      BackendFileEntity fileEntity = BackendFileEntity(
          filename: filename,
          fileType: fileType,
          thumbnailPath: thumbnailPath,
          imagePath: imagePath,
          temporaryImagePath: temporaryImagePath);

      String downloadID = uuid.v4();

      BackendDownloadEntity downloadEntity = BackendDownloadEntity(
        downloadID: downloadID,
        url: urlString,
        totalLength: response.contentLength ?? 0,
        fileEntity: fileEntity,
        stream: response.stream,
      );
      return ServiceResult<BackendDownloadEntity>.success(downloadEntity);
    } on http.ClientException catch (e) {
      return ServiceResult.error(NoInternetError(e.message));
    } catch (e) {
      return ServiceResult.error(e);
    }
  }
}
