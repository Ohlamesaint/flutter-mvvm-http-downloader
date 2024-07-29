import 'package:perfect_corp_homework/features/history/model/image_metadata_model.dart';

abstract interface class ImageMetadataRepository {
  Future<ImageMetadataModel> fetchImageMetaDataByImageName(
      String imageFileName);

  Future<void> addImageMetaData(ImageMetadataModel imageMetadataModel);
}
