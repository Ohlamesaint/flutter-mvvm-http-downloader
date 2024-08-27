import 'dart:convert';

import 'package:perfect_corp_homework/native/features/download/domain/repository/download_repository.dart';
import 'package:perfect_corp_homework/native/api/service_result.dart';
import 'package:perfect_corp_homework/native/features/download/data/mapper/raw_response_to_service_result_mapper.dart';
import 'package:download/download.dart';

final class DownloadRepositoryNativeImpl implements DownloadRepository {
  // return numbers of ongoing downloads

  Download downloader = Download();

  @override
  Future<ServiceResult<int>> createDownload(
      {required String urlString, required bool isConcurrent}) async {
    try {
      final Map<String, dynamic> methodChannelRawResponse = jsonDecode(
          await downloader.createDownload(
              urlString: urlString, isConcurrent: isConcurrent));
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
      final Map<String, dynamic> methodChannelRawResponse =
          jsonDecode(await downloader.cancelDownload(downloadID: downloadID));
      return RawResponseToServiceResultMapper<int>()
          .mapping(methodChannelRawResponse, null);
    } catch (e) {
      return ServiceResult<int>.error(e);
    }
  }

  @override
  Future<ServiceResult<int>> pauseDownload({required String downloadID}) async {
    try {
      final Map<String, dynamic> methodChannelRawResponse =
          jsonDecode(await downloader.pauseDownload(downloadID: downloadID));
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
      final Map<String, dynamic> methodChannelRawResponse =
          jsonDecode(await downloader.resumeDownload(downloadID: downloadID));
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
      final Map<String, dynamic> methodChannelRawResponse = jsonDecode(
          await downloader.manualPauseDownload(downloadID: downloadID));
      return RawResponseToServiceResultMapper<int>()
          .mapping(methodChannelRawResponse, null);
    } catch (e) {
      return ServiceResult<int>.error(e);
    }
  }

  @override
  ServiceResult<Stream> getDownloadListStream() {
    try {
      ServiceResult<Stream> result =
          ServiceResult.success(downloader.getDownloadListStream());
      return result;
    } catch (e) {
      return ServiceResult<Stream<String>>.error(e);
    }
  }

  @override
  ServiceResult<Stream> getFinishedEventStream() {
    try {
      ServiceResult<Stream> result =
          ServiceResult.success(downloader.getFinishedEventStream());
      return result;
    } catch (e) {
      return ServiceResult<Stream<String>>.error(e);
    }
  }
}
