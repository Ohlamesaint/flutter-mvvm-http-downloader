import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:perfect_corp_homework/native/api/service_result.dart';
import 'package:perfect_corp_homework/native/features/download/domain/entity/download_entity.dart';
import 'package:perfect_corp_homework/native/features/download/domain/repository/output/download_finished_response.dart';

import '../../domain/repository/download_repository.dart';
import '../../domain/repository/output/download_created_response.dart';
import '../mapper/raw_response_to_service_result_mapper.dart';
import '../model/download_created_response_model.dart';

class DownloadRepositoryNativeImpl implements DownloadRepository {
  final MethodChannel _methodChannel =
      const MethodChannel('http_downloader/downloadService');

  final EventChannel _eventChannel =
      const EventChannel('http_downloader/eventBasedDownloadService');

  // return numbers of ongoing downloads
  @override
  Future<ServiceResult<int>> createDownload({required String urlString}) async {
    try {
      Map<String, dynamic> methodChannelRawResponse =
          await _methodChannel.invokeMethod("initDownload", {
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

  // @override
  // Future<ServiceResult<FinishDownloadResponse>> downloadFinished(
  //     Map<String, dynamic> params) async {
  //   try {
  //     Map<String, dynamic> methodChannelRawResponse =
  //         await _methodChannel.invokeMethod("startDownload", {
  //       "downloadID": params['downloadID'],
  //     });
  //     return RawResponseToServiceResultMapper<FinishDownloadResponse>()
  //         .mapping(methodChannelRawResponse);
  //   } catch (e) {
  //     return ServiceResult<FinishDownloadResponse>.error(e);
  //   }
  // }
  //
  // @override
  // Future<ServiceResult<FinishDownloadResponse>> finishDownload(
  //     {required String downloadID}) {
  //   // TODO: implement finishDownload
  //   throw UnimplementedError();
  // }

  @override
  ServiceResult<Stream<List<DownloadEntity>>> getDownloadListStream() {
    try {
      ServiceResult<Stream<List<DownloadEntity>>> result =
          ServiceResult.success();
      result.data = _eventChannel.receiveBroadcastStream()
          as Stream<List<DownloadEntity>>?;
      return result;
    } catch (e) {
      return ServiceResult<Stream<List<DownloadEntity>>>.error(e);
    }
  }

  @override
  Future<ServiceResult<FinishDownloadResponse>> finishDownload(
      {required String downloadID}) {
    // TODO: implement finishDownload
    throw UnimplementedError();
  }
}
