import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:perfect_corp_homework/native/features/download/data/backend_service/service/backend_download_service_impl.dart';
import 'package:perfect_corp_homework/native/features/download/domain/entity/download_entity.dart';

import '../../../features/download/domain/repository/download_repository.dart';
import '../../../api/service_result.dart';
import '../model/image_model.dart';
import '../repository/image_repository.dart';
import '../../../injection_container.dart';
import '../../download/data/model/download_model.dart';

class HistoryViewModel extends ChangeNotifier {
  bool isFetchingData = true;

  List<ImageModel> imageModels = [];
  DownloadRepository downloadRepository;

  HistoryViewModel(this.downloadRepository) {
    downloadRepository
        .getFinishedEventStream()
        .data!
        .listen((finishedDownloadEntity) async {
      log(finishedDownloadEntity);
      await locator<ImageRepository>().saveImage(
          DownloadModel.fromJson(jsonDecode(finishedDownloadEntity)));
      await fetchImages();
    });
  }

  Future<void> fetchImages() async {
    isFetchingData = true;
    notifyListeners();

    ServiceResult<List<ImageModel>> serviceResult =
        await locator<ImageRepository>().fetchImages();
    if (serviceResult.error != null) {
      // TODO: Handle Error
      log("fetchImages ${serviceResult.getErrorMessage()}");
      return;
    }
    imageModels = serviceResult.data!;
    isFetchingData = false;
    notifyListeners();
  }
}
