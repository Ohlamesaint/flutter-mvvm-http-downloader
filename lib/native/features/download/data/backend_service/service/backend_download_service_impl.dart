import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:perfect_corp_homework/flutter/api/app_exception.dart';
import 'package:perfect_corp_homework/native/features/download/data/backend_service/api/service_result.dart';
import 'package:perfect_corp_homework/native/features/download/data/backend_service/model/backend_download_entity.dart';
import 'package:perfect_corp_homework/native/features/download/data/backend_service/repository/backend_download_repository.dart';
import 'package:perfect_corp_homework/native/features/download/data/backend_service/service/backend_download_service.dart';

class BackendDownloadServiceImpl implements BackendDownloadService {
  BackendDownloadRepository backendDownloadRepository;

  BackendDownloadServiceImpl(this.backendDownloadRepository);

  static StreamController<String> allDownloadStreamController =
      StreamController.broadcast();
  static StreamController<String> finishedDownloadStreamController =
      StreamController.broadcast();

  Map<String, BackendDownloadEntity> id2DownloadEntity = {};

  @override
  ServiceResult<Stream<String>> allDownloadEntityStream() {
    return ServiceResult.success(allDownloadStreamController.stream);
  }

  @override
  ServiceResult<int> cancelDownload({required String downloadID}) {
    if (!id2DownloadEntity.containsKey(downloadID)) {
      return ServiceResult<int>.error(UnknownError());
    }
    id2DownloadEntity[downloadID]!.cancelDownload();
    _sendUpdateAllDownloadEvent();
    return ServiceResult.success(_countOngoingDownload());
  }

  @override
  Future<ServiceResult<int>> createDownload({required String urlString}) async {
    try {
      ServiceResult<BackendDownloadEntity> serviceResult =
          await backendDownloadRepository.fetchImageWithUrl(
              urlString: urlString);
      if (!serviceResult.isSuccess) {
        return ServiceResult<int>.error(serviceResult.error);
      }

      BackendDownloadEntity newDownloadEntity = serviceResult.data!;
      id2DownloadEntity[newDownloadEntity.downloadID] = newDownloadEntity;
      _sendUpdateAllDownloadEvent();

      // init and configure subscription
      var file = File(newDownloadEntity.fileEntity.temporaryImagePath);
      var ioSink = file.openWrite();
      _configureSubscription(newDownloadEntity, ioSink, file);

      newDownloadEntity.resumeDownload();
      _sendUpdateAllDownloadEvent();

      return ServiceResult<int>.success(_countOngoingDownload());
    } catch (e) {
      return ServiceResult<int>.error(e);
    }
  }

  void _sendUpdateAllDownloadEvent() {
    List<String> raw = id2DownloadEntity.values
        .map((downloadEntity) => jsonEncode(downloadEntity))
        .toList();
    String newEvent = jsonEncode(raw);
    allDownloadStreamController.sink.add(newEvent);
  }

  void _sendDownloadFinishedEvent(BackendDownloadEntity finishedEntity) {
    String newEvent = jsonEncode(finishedEntity);
    finishedDownloadStreamController.sink.add(newEvent);
  }

  void _configureSubscription(
      BackendDownloadEntity downloadEntity, IOSink ioSink, File file) {
    downloadEntity.subscription =
        downloadEntity.stream.listen((List<int> value) {
      downloadEntity.updateProgress(value.length);

      ioSink.add(value);
      _sendUpdateAllDownloadEvent();
    });

    downloadEntity.subscription.onDone(() {
      _sendDownloadFinishedEvent(downloadEntity);
      downloadEntity.status = DownloadStatus.done;

      // release resource
      downloadEntity.subscription.cancel();
      ioSink.close();

      _sendUpdateAllDownloadEvent();
    });

    // download error occur
    downloadEntity.subscription.onError((Object e) {
      downloadEntity.errorDownload();

      // release resource
      downloadEntity.subscription.cancel();
      ioSink.close();
      file.delete();

      _sendUpdateAllDownloadEvent();
    });
  }

  @override
  ServiceResult<Stream<String>> finishedEntityStream() {
    return ServiceResult.success(finishedDownloadStreamController.stream);
  }

  @override
  ServiceResult<int> manualPauseDownload({required String downloadID}) {
    if (!id2DownloadEntity.containsKey(downloadID)) {
      return ServiceResult<int>.error(UnknownError());
    }
    id2DownloadEntity[downloadID]!.manualPauseDownload();
    _sendUpdateAllDownloadEvent();
    return ServiceResult.success(_countOngoingDownload());
  }

  @override
  ServiceResult<int> pauseDownload({required String downloadID}) {
    if (!id2DownloadEntity.containsKey(downloadID)) {
      return ServiceResult<int>.error(UnknownError());
    }
    id2DownloadEntity[downloadID]!.pauseDownload();
    _sendUpdateAllDownloadEvent();
    return ServiceResult.success(_countOngoingDownload());
  }

  @override
  ServiceResult<int> resumeDownload({required String downloadID}) {
    if (!id2DownloadEntity.containsKey(downloadID)) {
      return ServiceResult<int>.error(UnknownError());
    }
    id2DownloadEntity[downloadID]!.resumeDownload();
    _sendUpdateAllDownloadEvent();
    return ServiceResult.success(_countOngoingDownload());
  }

  _countOngoingDownload() {
    return id2DownloadEntity.values
        .where(
            (downloadEntity) => downloadEntity.status == DownloadStatus.ongoing)
        .length;
  }
}
