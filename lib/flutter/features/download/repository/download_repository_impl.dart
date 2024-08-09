import 'dart:async';

import '../../../api/app_exception.dart';
import '../../../api/service_result.dart';
import '../../../util/file_util.dart';
import 'download_repository.dart';
import '../model/download_model.dart';
import '../../../util/network_util.dart';
import '../model/download_file_model.dart';

import 'package:http/http.dart' as http;

class DownloadRepositoryImpl implements DownloadRepository {
  @override
  Future<ServiceResult<DownloadModel>> fetchImageWithUrl(
      {required String urlString}) async {
    ServiceResult<DownloadModel> serviceResult = ServiceResult.pending();
    try {
      http.StreamedResponse response =
          await NetworkUtil.fetchStreamImageDataWithUrlString(urlString);

      // generate temporary file name
      String fileType = response.headers['content-type']!.split('/')[1];
      String filename = FileUtil.generateFileName();

      // initialize download entity with callback from download view model

      DownloadFileModel downloadFileModel =
          DownloadFileModel(filename: filename, fileType: fileType);

      DownloadModel targetModel = DownloadModel(
        urlString: urlString,
        status: ServiceStatus.pending,
        targetLength: response.contentLength ?? 0,
        fileModel: downloadFileModel,
        stream: response.stream,
      );

      serviceResult.data = targetModel;
    } on http.ClientException catch (e) {
      return ServiceResult.error(NoInternetError(e.message));
    } catch (e) {
      return ServiceResult.error(e);
    }

    return serviceResult;
  }
}
