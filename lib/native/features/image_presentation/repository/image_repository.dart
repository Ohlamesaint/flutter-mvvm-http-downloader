import 'package:perfect_corp_homework/native/features/download/domain/entity/download_entity.dart';
import 'package:perfect_corp_homework/native/api/service_result.dart';
import 'package:perfect_corp_homework/native/features/image_presentation/model/image_model.dart';

abstract interface class ImageRepository {
  /// move the image file to persist directory and store metadata
  Future<ServiceResult<void>> saveImage(DownloadEntity downloadEntity);

  /// collect all image's metadata and file references
  Future<ServiceResult<List<ImageModel>>> fetchImages();
}
