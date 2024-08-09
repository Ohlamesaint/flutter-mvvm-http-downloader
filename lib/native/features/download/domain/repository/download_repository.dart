import '../../../../features/download/domain/entity/download_entity.dart';
import '../../../../api/service_result.dart';
import 'output/download_finished_response.dart';

abstract interface class DownloadRepository {
  ServiceResult<Stream<List<DownloadEntity>>> getDownloadListStream();
  Future<ServiceResult<int>> createDownload({required String urlString});
  Future<ServiceResult<int>> pauseDownload({required String downloadID});
  Future<ServiceResult<int>> resumeDownload({required String downloadID});
  Future<ServiceResult<int>> cancelDownload({required String downloadID});
  // Future<ServiceResult<void>> pauseAllDownload();
  // Future<ServiceResult<void>> resumeAllDownloadWithoutManualPaused();
  Future<ServiceResult<FinishDownloadResponse>> finishDownload(
      {required String downloadID});
}
