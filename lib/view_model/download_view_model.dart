import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../injection_container.dart';
import '../model/repository/download_repository_impl.dart';
import '../shared/api_response.dart';
import 'entity/download_entity.dart';

class DownloadViewModel extends ChangeNotifier {
  String url = '';
  bool needInput = false;
  late List<DownloadEntity> downloads = [];
  List<String> errorTriggered = [];
  DownloadViewModel();

  // user use cases
  Future<void> initDownloadList() async {}

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
    url = '';
    notifyListeners();
    await locator<DownloadRepositoryImpl>().fetchImageWithUrl(urlString: url);
  }

  DownloadEntity initDownloadEntity(
      {required String urlString,
      required int length,
      required String temporaryAbsolute}) {
    DownloadEntity newDownload = DownloadEntity(
      urlString: urlString,
      response: ApiResponse.pending('pending...'),
      targetLength: length,
      temporaryAbsolute: temporaryAbsolute,
    );
    downloads.add(newDownload);
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

  void pauseDownload(DownloadEntity downloadEntity) {
    downloadEntity.response = ApiResponse.paused('download paused...');
    downloadEntity.subscription.pause();
    notifyListeners();
  }

  void finishDownload(DownloadEntity downloadEntity) {
    downloadEntity.response = ApiResponse.done('download finished...');
    notifyListeners();
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
