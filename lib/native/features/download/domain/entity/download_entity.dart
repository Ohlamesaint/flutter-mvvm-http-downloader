import 'package:equatable/equatable.dart';

import 'file_entity.dart';

class DownloadEntity with EquatableMixin {
  String downloadID;
  String url;
  int totalLength;
  int currentLength;
  DownloadStatus status;

  FileEntity fileEntity;

  DownloadEntity({
    required this.downloadID,
    required this.url,
    required this.totalLength,
    required this.currentLength,
    required this.status,
    required this.fileEntity,
  });

  @override
  List<Object?> get props =>
      [downloadID, url, totalLength, currentLength, status];
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
