import 'package:equatable/equatable.dart';

import 'file_entity.dart';

class DownloadEntity with EquatableMixin {
  final String downloadID;
  final String url;
  final int totalLength;
  final int currentLength;
  final bool isConcurrent;
  final DownloadStatus status;

  final FileEntity fileEntity;

  DownloadEntity({
    required this.downloadID,
    required this.url,
    required this.totalLength,
    required this.currentLength,
    required this.status,
    required this.isConcurrent,
    required this.fileEntity,
  });

  @override
  List<Object?> get props =>
      [downloadID, url, totalLength, currentLength, isConcurrent, status];

  factory DownloadEntity.fromJson(Map<String, dynamic> json) => DownloadEntity(
        downloadID: json['downloadID'],
        url: json['url'],
        totalLength: json['totalLength'],
        currentLength: json['currentLength'],
        isConcurrent: json['isConcurrent'],
        status: DownloadStatus.fromJson(json['status']),
        fileEntity:
            FileEntity.fromJson(Map<String, dynamic>.from(json['fileEntity'])),
      );
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
