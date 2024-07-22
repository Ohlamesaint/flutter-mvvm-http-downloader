import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:perfect_corp_homework/model/repository/image_repository_impl.dart';

import '../injection_container.dart';
import '../model/ImageModel.dart';
import '../model/repository/download_repository_impl.dart';
import '../shared/api_response.dart';
import 'entity/download_entity.dart';

class DownloadViewModel extends ChangeNotifier {
  String url = '';
  bool needInput = false;
  late List<DownloadEntity> downloads = [];
  List<String> errorTriggered = [];

  // user use cases
  Future<void> initDownloadList() async {}

  void pauseAllDownload() {
    downloads
        .where((download) => download.response.apiStatus == Status.loading)
        .forEach(pauseDownload);
  }

  void resumeAllPausedDownload() {
    downloads
        .where((download) => download.response.apiStatus == Status.paused)
        .forEach(resumeDownload);
  }

  void urlInputChanged(String value) {
    url = value;
    if (value != '') needInput = false;
    notifyListeners();
  }

  void showNeedInput() {
    needInput = true;
    notifyListeners();
  }

  Future<void> fetchImage() async {
    // check if request is valid
    await locator<DownloadRepositoryImpl>().fetchImageWithUrl(urlString: url);
    url = '';
    notifyListeners();
  }

  DownloadEntity initDownloadEntity({
    required String urlString,
    required int length,
    required String temporaryAbsolute,
    required String filename,
  }) {
    DownloadEntity newDownload = DownloadEntity(
      urlString: urlString,
      response: ApiResponse.pending('pending...'),
      targetLength: length,
      temporaryAbsolute: temporaryAbsolute,
      filename: filename,
    );
    downloads.insert(0, newDownload);
    notifyListeners();
    return newDownload;
  }

  void updateDownloadEntity(
      {required DownloadEntity downloadEntity, required int length}) {
    downloadEntity.currentLength += length;
    notifyListeners();
  }

  void startDownload(DownloadEntity downloadEntity) {
    downloadEntity.response = ApiResponse.loading('download started...');
    notifyListeners();
  }

  void resumeDownload(DownloadEntity downloadEntity) {
    downloadEntity.response = ApiResponse.loading('download resumed...');
    downloadEntity.subscription.resume();
    notifyListeners();
  }

  void manualPauseDownload(DownloadEntity downloadEntity) {
    downloadEntity.response =
        ApiResponse.manualPaused('download manual paused...');
    downloadEntity.subscription.pause();
    notifyListeners();
  }

  void pauseDownload(DownloadEntity downloadEntity) {
    downloadEntity.response = ApiResponse.paused('download manual paused...');
    downloadEntity.subscription.pause();
    notifyListeners();
  }

  void finishDownload(DownloadEntity downloadEntity) async {
    downloadEntity.response = ApiResponse.done('download finished...');
    notifyListeners();

    // add metadata to fire store
    await locator<ImageRepositoryImpl>().addImageMetaData(ImageModel(
      url: downloadEntity.urlString,
      filename: downloadEntity.filename,
    ));
  }

  void errorDownload(DownloadEntity downloadEntity) {
    downloadEntity.response = ApiResponse.error('download failed...');
    notifyListeners();
  }

  void cancelDownload(DownloadEntity downloadEntity) {
    downloadEntity.response = ApiResponse.cancel('download canceled...');
    downloadEntity.subscription.cancel();
    notifyListeners();
  }

  void showError(String message) {
    errorTriggered.add(message);
  }
}
