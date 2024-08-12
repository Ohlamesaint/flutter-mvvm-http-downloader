import 'package:perfect_corp_homework/native/features/download/data/backend_service/model/backend_download_entity.dart';
import '../api/service_result.dart';

abstract interface class BackendDownloadRepository {
  Future<ServiceResult<BackendDownloadEntity>> fetchImageWithUrl(
      {required String urlString});
}
