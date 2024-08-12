import '../../../features/download/domain/entity/download_entity.dart';
import '../../../api/service_result.dart';
import '../../download/domain/entity/file_entity.dart';
import '../model/image_model.dart';

abstract interface class ImageRepository {
  /// move the image file to persist directory and store metadata
  Future<ServiceResult<void>> saveImage(DownloadEntity downloadEntity);

  /// collect all image's metadata and file references
  Future<ServiceResult<List<ImageModel>>> fetchImages();
}
