import 'dart:convert';

import 'package:perfect_corp_homework/native/features/download/data/backend_service/controller/backend_download_controller.dart';
import 'package:perfect_corp_homework/native/features/download/data/backend_service/controller/mapper/service_result_to_raw_response.dart';
import 'package:perfect_corp_homework/native/features/download/data/backend_service/model/backend_download_entity.dart';
import 'package:perfect_corp_homework/native/features/download/data/backend_service/service/backend_download_service.dart';
import 'package:perfect_corp_homework/native/features/download/data/backend_service/api/service_result.dart';

class BackendDownloadControllerImpl implements BackendDownloadController {
  BackendDownloadService backendDownloadService;

  BackendDownloadControllerImpl(this.backendDownloadService);

  @override
  String cancelDownload({required String downloadID}) {
    ServiceResult<int> serviceResult =
        backendDownloadService.cancelDownload(downloadID: downloadID);
    MethodChannelResponse<int> methodChannelResponse =
        ServiceResultToMethodChannelResponseMapper<int>()
            .mapping(serviceResult, null);

    return jsonEncode(methodChannelResponse);
  }

  @override
  Future<String> createDownload({required String urlString}) async {
    try {
      ServiceResult<int> serviceResult =
          await backendDownloadService.createDownload(urlString: urlString);

      MethodChannelResponse<int> methodChannelResponse =
          ServiceResultToMethodChannelResponseMapper<int>()
              .mapping(serviceResult, null);
      return jsonEncode(methodChannelResponse);
    } catch (e) {
      return jsonEncode(MethodChannelResponse.unknownError(e.toString()));
    }
  }

  @override
  String resolveFinishedEvent() {
    ServiceResult serviceResult = backendDownloadService.finishedEntityStream();

    return jsonEncode(ServiceResultToMethodChannelResponseMapper<
            Stream<BackendDownloadEntity>>()
        .mapping(serviceResult, null));
  }

  @override
  String resolveDownloadStatusUpdateEvent() {
    ServiceResult serviceResult =
        backendDownloadService.allDownloadEntityStream();

    return jsonEncode(
        ServiceResultToMethodChannelResponseMapper<Stream<String>>()
            .mapping(serviceResult, null));
  }

  @override
  String pauseDownload({required String downloadID}) {
    ServiceResult<int> serviceResult =
        backendDownloadService.pauseDownload(downloadID: downloadID);
    MethodChannelResponse<int> methodChannelResponse =
        ServiceResultToMethodChannelResponseMapper<int>()
            .mapping(serviceResult, null);

    return jsonEncode(methodChannelResponse);
  }

  @override
  String resumeDownload({required String downloadID}) {
    ServiceResult<int> serviceResult =
        backendDownloadService.resumeDownload(downloadID: downloadID);
    MethodChannelResponse<int> methodChannelResponse =
        ServiceResultToMethodChannelResponseMapper<int>()
            .mapping(serviceResult, null);

    return jsonEncode(methodChannelResponse);
  }
}
