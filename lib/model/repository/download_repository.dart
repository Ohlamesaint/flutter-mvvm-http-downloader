import '../../view_model/entity/download_entity.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

abstract interface class DownloadRepository {
  // fetch download entities stored in download directory
  List<DownloadEntity> fetchDownloadList();

  // fetch image from the network
  Future<void> fetchImageWithUrl({required String urlString});
}
