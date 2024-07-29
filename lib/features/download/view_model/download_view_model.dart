import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:perfect_corp_homework/api/app_exception.dart';
import 'package:perfect_corp_homework/features/download/repository/file_repository_impl.dart';
import 'package:perfect_corp_homework/model/repository/image_repository_impl.dart';

import '../../../api/service_result.dart';
import '../../../util/file_util.dart';
import '../repository/download_repository_impl.dart';
import '../../../injection_container.dart';
import '../../../model/ImageModel.dart';
import '../model/download_model.dart';

class DownloadViewModel extends ChangeNotifier {
  String url = '';
  bool needInput = false;
  late List<DownloadModel> downloads = [];

  final animatedListGlobalKey = GlobalKey<AnimatedListState>();

  void urlInputChanged(String value) {
    url = value;
    if (value != '') needInput = false;
    notifyListeners();
  }

  void showNeedInput() {
    needInput = true;
    notifyListeners();
  }

  /// for screen off
  void pauseAllDownload() {
    downloads
        .where((download) => download.status == ServiceStatus.loading)
        .forEach(pauseDownload);
  }

  /// for screen on
  void resumeAllPausedDownload() {
    downloads
        .where((download) => download.status == ServiceStatus.paused)
        .forEach(resumeDownload);
  }

  /// trigger when user press download button
  Future<void> downloadImage() async {
    ServiceResult<DownloadModel> response =
        await locator<DownloadRepositoryImpl>()
            .fetchImageWithUrl(urlString: url);

    if (response.error != null) {
      switch (response.error.runtimeType) {
        case BadRequestError _:
        // TODO Handle BadRequestError;
        case UnSupportImageTypeError _:
        // TODO Handle UnSupportImageTypeError;
        case _:
      }
      return;
    }

    startDownload(response.data!);

    /// clear the text field
    url = '';
    notifyListeners();
  }

  void startDownload(DownloadModel downloadModel) async {
    // open temporary file
    var file = File(await downloadModel.fileModel.generateTemporaryFileName());
    var ioSink = file.openWrite();

    // init and configure subscription
    initDownloadSubscription(downloadModel, ioSink, file);

    downloads.insert(0, downloadModel);
    if (animatedListGlobalKey.currentState != null) {
      animatedListGlobalKey.currentState!.insertItem(0);
    }
    notifyListeners();
  }

  // init and configure subscription
  void initDownloadSubscription(
      DownloadModel downloadModel, IOSink ioSink, File file) {
    downloadModel.status = ServiceStatus.loading;

    downloadModel.subscription = downloadModel.stream.listen((List<int> value) {
      updateDownloadEntity(downloadModel: downloadModel, length: value.length);
      ioSink.add(value);
    });

    downloadModel.subscription.onDone(() async {
      finishDownload(downloadModel);

      // release resource
      downloadModel.subscription.cancel();
      ioSink.close();

      locator<FileRepositoryImpl>().persistFile(downloadModel.fileModel);
    });

    // download error occur
    downloadModel.subscription.onError((Object e) {
      errorDownload(downloadModel, e);

      // release resource
      downloadModel.subscription.cancel();
      ioSink.close();
      file.delete();
    });

    notifyListeners();
  }

  void updateDownloadEntity(
      {required DownloadModel downloadModel, required int length}) {
    downloadModel.currentLength += length;
    notifyListeners();
  }

  void resumeDownload(DownloadModel downloadModel) {
    downloadModel.status = ServiceStatus.loading;
    downloadModel.subscription.resume();
    notifyListeners();
  }

  void manualPauseDownload(DownloadModel downloadEntity) {
    downloadEntity.status = ServiceStatus.manualPaused;
    downloadEntity.subscription.pause();
    notifyListeners();
  }

  void pauseDownload(DownloadModel downloadEntity) {
    downloadEntity.status = ServiceStatus.paused;
    downloadEntity.subscription.pause();
    notifyListeners();
  }

  void finishDownload(DownloadModel downloadModel) async {
    downloadModel.status = ServiceStatus.done;
    notifyListeners();

    // TODO: add metadata to fire store
    await locator<ImageRepositoryImpl>().addImageMetaData(ImageModel(
      url: downloadModel.urlString,
      filename: downloadModel.fileModel.filename,
    ));
  }

  void errorDownload(DownloadModel downloadEntity, Object error) {
    downloadEntity.status = ServiceStatus.error;
    log(error.toString());
    notifyListeners();
  }

  void cancelDownload(DownloadModel downloadEntity) {
    downloadEntity.status = ServiceStatus.cancel;
    downloadEntity.subscription.cancel();
    notifyListeners();
  }
}
