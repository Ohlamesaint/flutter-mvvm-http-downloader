import 'dart:developer';

import 'package:flutter/cupertino.dart';

import '../../../api/service_result.dart';
import '../model/image_model.dart';
import '../repository/image_repository.dart';
import '../../../injection_container.dart';

class HistoryViewModel extends ChangeNotifier {
  bool isFetchingData = true;

  List<ImageModel> imageModels = [];

  Future<void> fetchImages() async {
    isFetchingData = true;
    notifyListeners();

    ServiceResult<List<ImageModel>> serviceResult =
        await locator<ImageRepository>().fetchImages();
    if (serviceResult.error != null) {
      // TODO: Handle Error
      log(serviceResult.getErrorMessage());
      return;
    }
    imageModels = serviceResult.data!;
    isFetchingData = false;
    notifyListeners();
  }
}
