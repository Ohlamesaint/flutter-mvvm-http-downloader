import 'package:perfect_corp_homework/native/api/service_result.dart';
import 'package:perfect_corp_homework/native/features/download/domain/entity/download_entity.dart';

import 'package:perfect_corp_homework/native/features/download/domain/repository/output/download_created_response.dart';

import 'package:perfect_corp_homework/native/features/download/domain/repository/output/download_finished_response.dart';

import '../../../../features/download/domain/repository/download_repository.dart';

class DownloadRepositoryFlutterImpl implements DownloadRepository {
  @override
  Future<ServiceResult<int>> cancelDownload({required String downloadID}) {
    // TODO: implement cancelDownload
    throw UnimplementedError();
  }

  @override
  Future<ServiceResult<int>> createDownload({required String urlString}) {
    // TODO: implement createDownload
    throw UnimplementedError();
  }

  @override
  Future<ServiceResult<FinishDownloadResponse>> finishDownload(
      {required String downloadID}) {
    // TODO: implement finishDownload
    throw UnimplementedError();
  }

  @override
  ServiceResult<Stream<List<DownloadEntity>>> getDownloadListStream() {
    // TODO: implement getDownloadListStream
    throw UnimplementedError();
  }

  @override
  Future<ServiceResult<int>> pauseDownload({required String downloadID}) {
    // TODO: implement pauseDownload
    throw UnimplementedError();
  }

  @override
  Future<ServiceResult<int>> resumeDownload({required String downloadID}) {
    // TODO: implement resumeDownload
    throw UnimplementedError();
  }
}
