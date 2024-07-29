import 'dart:async';

import 'package:perfect_corp_homework/api/service_result.dart';

import 'download_file_model.dart';

class DownloadModel {
  String urlString;
  ServiceStatus status;
  int targetLength;
  int currentLength = 0;
  Stream<List<int>> stream;
  late DownloadFileModel fileModel;
  late StreamSubscription<List<int>> subscription;

  DownloadModel({
    required this.urlString,
    required this.status,
    required this.targetLength,
    required this.fileModel,
    required this.stream,
  });
}
