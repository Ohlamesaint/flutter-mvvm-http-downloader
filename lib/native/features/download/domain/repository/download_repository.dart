import '../../../../features/download/domain/entity/download_entity.dart';
import '../../../../api/service_result.dart';

abstract interface class DownloadRepository {
  ServiceResult<Stream> getDownloadListStream();
  Future<ServiceResult<int>> createDownload({required String urlString});
  Future<ServiceResult<int>> pauseDownload({required String downloadID});
  Future<ServiceResult<int>> resumeDownload({required String downloadID});
  Future<ServiceResult<int>> cancelDownload({required String downloadID});
  Future<ServiceResult<int>> manualPauseDownload({required String downloadID});
  // Future<ServiceResult<void>> pauseAllDownload();
  // Future<ServiceResult<void>> resumeAllDownloadWithoutManualPaused();
  ServiceResult<Stream> finishDownload({required String downloadID});
}
