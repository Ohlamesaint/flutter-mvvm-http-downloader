import '../api/service_result.dart';

abstract interface class BackendDownloadService {
  Future<ServiceResult<int>> createDownload({required String urlString});
  ServiceResult<int> pauseDownload({required String downloadID});
  ServiceResult<int> manualPauseDownload({required String downloadID});
  ServiceResult<int> resumeDownload({required String downloadID});
  ServiceResult<int> cancelDownload({required String downloadID});
  ServiceResult<Stream<String>> allDownloadEntityStream();
  ServiceResult<Stream<String>> finishedEntityStream();
}
