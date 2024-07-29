import 'dart:async';
import '../../../api/service_result.dart';
import '../model/download_model.dart';

abstract interface class DownloadRepository {
  // fetch image from the network
  Future<ServiceResult<DownloadModel>> fetchImageWithUrl(
      {required String urlString});
}
