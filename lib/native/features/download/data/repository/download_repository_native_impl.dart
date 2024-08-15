import 'dart:developer';

import 'package:flutter/services.dart';
import '../../domain/repository/download_repository.dart';
import '../../../../api/service_result.dart';
import '../mapper/raw_response_to_service_result_mapper.dart';
import '../../domain/entity/download_entity.dart';

class DownloadRepositoryNativeImpl implements DownloadRepository {
  // return numbers of ongoing downloads

  late EventChannel _progressEventChannel;
  late EventChannel _finishedEventChannel;
  late MethodChannel _methodChannel;

  DownloadRepositoryNativeImpl() {
    log("created");
    _progressEventChannel =
        const EventChannel('http_downloader/download/progress');
    _finishedEventChannel =
        const EventChannel('http_downloader/download/finished');
    _methodChannel = const MethodChannel('http_downloader/download');
  }

  @override
  Future<ServiceResult<int>> createDownload({required String urlString}) async {
    try {
      Map<String, dynamic> methodChannelRawResponse =
          await _methodChannel.invokeMethod("createDownload", {
        "urlString": urlString,
      });
      return RawResponseToServiceResultMapper<int>()
          .mapping(methodChannelRawResponse, null);
    } catch (e) {
      return ServiceResult<int>.error(e);
    }
  }

  @override
  Future<ServiceResult<int>> cancelDownload(
      {required String downloadID}) async {
    try {
      Map<String, dynamic> methodChannelRawResponse =
          await _methodChannel.invokeMethod("cancelDownload", {
        "downloadID": downloadID,
      });
      return RawResponseToServiceResultMapper<int>()
          .mapping(methodChannelRawResponse, null);
    } catch (e) {
      return ServiceResult<int>.error(e);
    }
  }

  @override
  Future<ServiceResult<int>> pauseDownload({required String downloadID}) async {
    try {
      Map<String, dynamic> methodChannelRawResponse =
          await _methodChannel.invokeMethod("pauseDownload", {
        "downloadID": downloadID,
      });
      return RawResponseToServiceResultMapper<int>()
          .mapping(methodChannelRawResponse, null);
    } catch (e) {
      return ServiceResult<int>.error(e);
    }
  }

  @override
  Future<ServiceResult<int>> resumeDownload(
      {required String downloadID}) async {
    try {
      Map<String, dynamic> methodChannelRawResponse =
          await _methodChannel.invokeMethod("resumeDownload", {
        "downloadID": downloadID,
      });
      return RawResponseToServiceResultMapper<int>()
          .mapping(methodChannelRawResponse, null);
    } catch (e) {
      return ServiceResult<int>.error(e);
    }
  }

  @override
  Future<ServiceResult<int>> manualPauseDownload(
      {required String downloadID}) async {
    try {
      Map<String, dynamic> methodChannelRawResponse =
          await _methodChannel.invokeMethod("manualPauseDownload", {
        "downloadID": downloadID,
      });
      return RawResponseToServiceResultMapper<int>()
          .mapping(methodChannelRawResponse, null);
    } catch (e) {
      return ServiceResult<int>.error(e);
    }
  }

  @override
  ServiceResult<Stream<String>> getDownloadListStream() {
    try {
      ServiceResult<Stream<String>> result = ServiceResult.success(
          _progressEventChannel.receiveBroadcastStream() as Stream<String>);
      return result;
    } catch (e) {
      return ServiceResult<Stream<String>>.error(e);
    }
  }

  @override
  ServiceResult<Stream<String>> finishDownload({required String downloadID}) {
    try {
      ServiceResult<Stream<String>> result = ServiceResult.success(
          _finishedEventChannel.receiveBroadcastStream() as Stream<String>);
      return result;
    } catch (e) {
      return ServiceResult<Stream<String>>.error(e);
    }
  }
}
