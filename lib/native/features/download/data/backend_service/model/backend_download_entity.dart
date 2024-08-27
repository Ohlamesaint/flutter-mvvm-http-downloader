import 'dart:async';

import 'package:perfect_corp_homework/native/features/download/data/backend_service/model/backend_file_entity.dart';

class BackendDownloadEntity {
  String downloadID;
  String url;
  int totalLength;
  int currentLength = 0;
  DownloadStatus status = DownloadStatus.pending;

  // TODO: decouple with stream
  Stream<List<int>> stream;
  late StreamSubscription<List<int>> subscription;

  BackendFileEntity fileEntity;

  BackendDownloadEntity({
    required this.downloadID,
    required this.url,
    required this.totalLength,
    required this.fileEntity,
    required this.stream,
  });

  void updateProgress(int value) {
    currentLength += value;
  }

  void pauseDownload() {
    subscription.pause();
    status = DownloadStatus.paused;
  }

  void resumeDownload() {
    subscription.resume();
    status = DownloadStatus.ongoing;
  }

  void manualPauseDownload() {
    subscription.pause();
    status = DownloadStatus.manualPaused;
  }

  void cancelDownload() {
    subscription.cancel();
    status = DownloadStatus.canceled;
    fileEntity.removeTemporary();
  }

  void errorDownload() {
    status = DownloadStatus.failed;
    fileEntity.removeTemporary();
  }

  Map<String, dynamic> toJson() => {
        'downloadID': downloadID,
        'url': url,
        'totalLength': totalLength,
        'currentLength': currentLength,
        'status': status.toJson(),
        'fileEntity': fileEntity.toJson(),
      };

  factory BackendDownloadEntity.fromJson(Map<String, dynamic> json) =>
      BackendDownloadEntity(
          downloadID: json['downloadID'],
          url: json['url'],
          totalLength: json['totalLength'],
          fileEntity: BackendFileEntity.fromJson(json['fileEntity']),
          stream: json['stream']);
}

enum DownloadStatus {
  pending,
  ongoing,
  paused,
  manualPaused,
  canceled,
  failed,
  done;

  String toJson() => name;
  factory DownloadStatus.fromJson(String json) => values.byName(json);
}
