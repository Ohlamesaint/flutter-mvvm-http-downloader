import '../../../../../../flutter/api/service_result.dart';
import '../../model/download_created_response_model.dart';
import '../model/backend_download_model.dart';
import '../util/uuid.dart';

class BackendDownloadService {
  Map<String, BackendDownloadModel> id2DownloadModel = {};

  Future<ServiceResult<DownloadCreatedResponseModel>> createDownload(
      {required String urlString}) {
    String downloadID = uuid.v4();

    // BackendDownloadModel backendDownloadModel = BackendDownloadModel(url: urlString, downloadID: downloadID, totalLength, stream)
  }
  // Future<ServiceResult<DownloadModel>> fetchImageWithUrl(
  //     {required String urlString}) async {
  //   ServiceResult<DownloadModel> serviceResult = ServiceResult.pending();
  //   try {
  //     http.StreamedResponse response =
  //     await NetworkUtil.fetchStreamImageDataWithUrlString(urlString);
  //
  //     // generate temporary file name
  //     String fileType = response.headers['content-type']!.split('/')[1];
  //     String filename = FileUtil.generateFileName();
  //
  //     // initialize download entity with callback from download view model
  //
  //     DownloadFileModel downloadFileModel =
  //     DownloadFileModel(filename: filename, fileType: fileType);
  //
  //     DownloadModel targetModel = DownloadModel(
  //       urlString: urlString,
  //       status: ServiceStatus.pending,
  //       targetLength: response.contentLength ?? 0,
  //       fileModel: downloadFileModel,
  //       stream: response.stream,
  //     );
  //
  //     serviceResult.data = targetModel;
  //   } on http.ClientException catch (e) {
  //     return ServiceResult.error(NoInternetError(e.message));
  //   } catch (e) {
  //     return ServiceResult.error(e);
  //   }
  //
  //   return serviceResult;
  // }
}
