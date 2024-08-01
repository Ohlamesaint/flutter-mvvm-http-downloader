import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:perfect_corp_homework/api/app_exception.dart';
import 'package:perfect_corp_homework/constant.dart';
import 'package:perfect_corp_homework/features/image_presentation/repository/image_repository.dart';

import '../../../api/service_result.dart';
import '../repository/download_repository.dart';
import '../../../injection_container.dart';
import '../model/download_model.dart';

class DownloadViewModel extends ChangeNotifier {
  String url = '';
  bool needInput = false;
  bool showErrorDialog = false;
  String dialogErrorMessage = '';
  late List<DownloadModel> downloads = [];

  final animatedListGlobalKey = GlobalKey<AnimatedListState>();

  void closeErrorDialog() {
    showErrorDialog = false;
    notifyListeners();
  }

  /// onChange() for url input text field
  void urlInputChanged(String value) {
    url = value;
    if (value != '') needInput = false;
    notifyListeners();
  }

  /// show error message for empty url input
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

  /// triggered when user press download button
  Future<void> downloadImage() async {
    ServiceResult<DownloadModel> response =
        await locator<DownloadRepository>().fetchImageWithUrl(urlString: url);

    if (response.error != null) {
      // set error dialog content
      switch (response.error.runtimeType) {
        case BadRequestError:
          dialogErrorMessage = kBadRequestErrorMessage;
        case UnSupportImageTypeError:
          dialogErrorMessage = kUnSupportMediaTypeErrorMessage;
        case NoInternetError:
          dialogErrorMessage = kNoInternetErrorMessage;
        default:
          dialogErrorMessage = 'The format of the input url is wrong!';
      }

      // set error dialog show
      showErrorDialog = true;
      url = '';
      notifyListeners();
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

  /// init and configure subscription
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

      // store image to the persist directory and the metadata to the firebase
      await locator<ImageRepository>().saveImage(downloadModel);

      // TODO use snack bar to notify download finish
    });

    // download error occur
    downloadModel.subscription.onError((Object e) {
      errorDownload(downloadModel, e);

      // release resource
      downloadModel.subscription.cancel();
      ioSink.close();
      file.delete();

      // TODO use snack bar to notify download error
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

  void manualPauseDownload(DownloadModel downloadModel) {
    downloadModel.status = ServiceStatus.manualPaused;
    downloadModel.subscription.pause();
    notifyListeners();
  }

  void pauseDownload(DownloadModel downloadModel) {
    downloadModel.status = ServiceStatus.paused;
    downloadModel.subscription.pause();
    notifyListeners();
  }

  void finishDownload(DownloadModel downloadModel) async {
    downloadModel.status = ServiceStatus.done;
    notifyListeners();
  }

  void errorDownload(DownloadModel downloadModel, Object error) {
    downloadModel.status = ServiceStatus.error;
    log(error.toString());
    notifyListeners();
  }

  void cancelDownload(DownloadModel downloadModel) {
    downloadModel.status = ServiceStatus.cancel;
    downloadModel.subscription.cancel();
    notifyListeners();
  }
}
