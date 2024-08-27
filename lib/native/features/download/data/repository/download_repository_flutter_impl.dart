import 'dart:convert';
import 'dart:developer';

import 'package:perfect_corp_homework/native/api/service_result.dart';
import 'package:perfect_corp_homework/native/features/download/data/backend_service/controller/backend_download_controller.dart';
import 'package:perfect_corp_homework/native/features/download/data/backend_service/service/backend_download_service_impl.dart';
import 'package:perfect_corp_homework/native/features/download/data/mapper/raw_response_to_service_result_mapper.dart';

import '../../../../features/download/domain/repository/download_repository.dart';

final class DownloadRepositoryFlutterImpl implements DownloadRepository {
  BackendDownloadController backendDownloadController;

  DownloadRepositoryFlutterImpl(this.backendDownloadController);

  @override
  Future<ServiceResult<int>> cancelDownload(
      {required String downloadID}) async {
    try {
      MethodChannelResponse<int> response = MethodChannelResponse<int>.fromJson(
          jsonDecode(backendDownloadController.cancelDownload(
              downloadID: downloadID)));
      return MethodChannelResponseToServiceResultMapper<int>()
          .mapping(response, null);
    } catch (e) {
      log('cancelDownload: ${e.toString()}');
      return ServiceResult<int>.error(e);
    }
  }

  @override
  Future<ServiceResult<int>> createDownload(
      {required String urlString, required bool isConcurrent}) async {
    try {
      MethodChannelResponse<int> response = MethodChannelResponse<int>.fromJson(
          jsonDecode(await backendDownloadController.createDownload(
              urlString: urlString)));
      return MethodChannelResponseToServiceResultMapper<int>()
          .mapping(response, null);
    } catch (e) {
      log('createDownload: ${e.toString()}');
      return ServiceResult<int>.error(e);
    }
  }

  @override
  Future<ServiceResult<int>> pauseDownload({required String downloadID}) async {
    try {
      MethodChannelResponse<int> response = MethodChannelResponse<int>.fromJson(
          jsonDecode(
              backendDownloadController.pauseDownload(downloadID: downloadID)));
      return MethodChannelResponseToServiceResultMapper<int>()
          .mapping(response, null);
    } catch (e) {
      log('pauseDownload: ${e.toString()}');
      return ServiceResult<int>.error(e);
    }
  }

  @override
  Future<ServiceResult<int>> resumeDownload(
      {required String downloadID}) async {
    try {
      MethodChannelResponse<int> response = MethodChannelResponse<int>.fromJson(
          jsonDecode(backendDownloadController.resumeDownload(
              downloadID: downloadID)));
      return MethodChannelResponseToServiceResultMapper<int>()
          .mapping(response, null);
    } catch (e) {
      log('resumeDownload: ${e.toString()}');
      return ServiceResult<int>.error(e);
    }
  }

  @override
  ServiceResult<Stream> getFinishedEventStream() {
    try {
      return ServiceResult.success(
          BackendDownloadServiceImpl.finishedDownloadStreamController.stream);
    } catch (e) {
      log('finishDownload: ${e.toString()}');
      return ServiceResult<Stream>.error(e);
    }
  }

  @override
  ServiceResult<Stream> getDownloadListStream() {
    try {
      return ServiceResult.success(
          BackendDownloadServiceImpl.allDownloadStreamController.stream);
    } catch (e) {
      log('getDownloadListStream: ${e.toString()}');
      return ServiceResult<Stream>.error(e);
    }
  }

  @override
  Future<ServiceResult<int>> manualPauseDownload({required String downloadID}) {
    // TODO: implement manualPauseDownload
    throw UnimplementedError();
  }
}
