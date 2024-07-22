import 'package:flutter/cupertino.dart';

import '../ImageModel.dart';

abstract interface class ImageRepository {
  Future<List<FileImage>> fetchThumbnails();

  Future<ImageModel> fetchImageMetaDataByImageName(String imageFileName);

  Future<void> addImageMetaData(ImageModel imageModel);
}
