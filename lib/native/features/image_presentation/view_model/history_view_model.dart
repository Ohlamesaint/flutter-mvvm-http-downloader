import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';

import 'package:perfect_corp_homework/native/features/download/domain/repository/download_repository.dart';
import 'package:perfect_corp_homework/native/api/service_result.dart';
import 'package:perfect_corp_homework/native/features/image_presentation/model/image_model.dart';
import 'package:perfect_corp_homework/native/features/image_presentation/repository/image_repository.dart';
import 'package:perfect_corp_homework/native/injection_container.dart';
import 'package:perfect_corp_homework/native/features/download/domain/entity/download_entity.dart';

class HistoryViewModel extends ChangeNotifier {
  bool isFetchingData = true;

  List<ImageModel> imageModels = [];
  DownloadRepository downloadRepository;

  HistoryViewModel(this.downloadRepository) {
    downloadRepository
        .getFinishedEventStream()
        .data!
        .listen((finishedDownloadEntity) async {
      await locator<ImageRepository>().saveImage(
        DownloadEntity.fromJson(
          Map<String, dynamic>.from(finishedDownloadEntity),
        ),
      );
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
    print(imageModels);
    isFetchingData = false;
    notifyListeners();
  }
}
