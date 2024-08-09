import 'dart:async';

import '../../../api/service_result.dart';
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

// class download_entity.dart {
//   final String downloadID;
//   final String urlString;
//   final int targetLength;
//   int currentLength = 0;
//   final Stream<DownloadProcessEntity> downloadStream;
//   final DownloadFileModel fileModel;
//   ServiceStatus status = ServiceStatus.pending;
//   late StreamSubscription<DownloadProcessEntity> download_subscription;
//
//   download_entity.dart({
//     required this.downloadID,
//     required this.urlString,
//     required this.status,
//     required this.targetLength,
//     required this.fileModel,
//     required this.downloadStream,
//   });
// }
