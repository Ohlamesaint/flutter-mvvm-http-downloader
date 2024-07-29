import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:perfect_corp_homework/model/repository/image_repository_impl.dart';

import '../injection_container.dart';
import 'entity/history_entity.dart';

class HistoryViewModel extends ChangeNotifier {
  bool isLoading = true;
  bool isFetchingImageMetaData = true;
  bool isFetchingData = true;

  late List<FileImage> thumbnails;
  late List<FileImage> images;
  late HistoryEntity imageDetail;

  Future<void> fetchImages() async {
    isFetchingData = true;
    notifyListeners();
    Directory dir = await getApplicationDocumentsDirectory();
    var imageFileList = await dir.list().toList();
    images = imageFileList.whereType<File>().map((file) {
      return FileImage(file);
    }).toList();
    images.sort((a, b) =>
        -a.file.statSync().changed.compareTo(b.file.statSync().changed));
    isFetchingData = false;
    notifyListeners();
  }

  Future<void> fetchThumbnails() async {
    isLoading = true;
    notifyListeners();
    thumbnails = await locator<ImageRepositoryImpl>().fetchThumbnails();
    thumbnails.sort((a, b) =>
        -a.file.statSync().changed.compareTo(b.file.statSync().changed));
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchImageMetaData(String imageName) async {
    isFetchingImageMetaData = true;
    notifyListeners();
    var imageModel = await locator<ImageRepositoryImpl>()
        .fetchImageMetaDataByImageName(imageName);
    imageDetail =
        HistoryEntity(imageUrl: imageModel.url, filename: imageModel.filename);
    isFetchingImageMetaData = false;
    notifyListeners();
  }
}
