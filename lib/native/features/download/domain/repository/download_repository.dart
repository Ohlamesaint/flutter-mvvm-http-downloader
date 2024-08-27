import 'package:perfect_corp_homework/native/api/service_result.dart';

abstract interface class DownloadRepository {
  ServiceResult<Stream> getDownloadListStream();
  Future<ServiceResult<int>> createDownload(
      {required String urlString, required bool isConcurrent});
  Future<ServiceResult<int>> pauseDownload({required String downloadID});
  Future<ServiceResult<int>> resumeDownload({required String downloadID});
  Future<ServiceResult<int>> cancelDownload({required String downloadID});
  Future<ServiceResult<int>> manualPauseDownload({required String downloadID});
  // Future<ServiceResult<void>> pauseAllDownload();
  // Future<ServiceResult<void>> resumeAllDownloadWithoutManualPaused();
  ServiceResult<Stream> getFinishedEventStream();
}
