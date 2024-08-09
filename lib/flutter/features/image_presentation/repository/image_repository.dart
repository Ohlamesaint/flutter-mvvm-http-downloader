import 'package:perfect_corp_homework/flutter/features/download/model/download_model.dart';

import '../../../api/service_result.dart';
import '../model/image_model.dart';

abstract interface class ImageRepository {
  /// move the image file to persist directory and store metadata
  Future<ServiceResult<void>> saveImage(DownloadModel downloadModel);

  /// collect all image's metadata and file references
  Future<ServiceResult<List<ImageModel>>> fetchImages();
}
