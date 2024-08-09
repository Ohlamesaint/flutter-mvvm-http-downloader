import 'package:equatable/equatable.dart';
import 'package:perfect_corp_homework/native/features/download/domain/repository/output/download_created_response.dart';

import '../repository/output/download_progress_response.dart';

class DownloadEntity with EquatableMixin {
  String downloadID;
  String url;
  int totalLength;
  int currentLength = 0;
  DownloadStatus status = DownloadStatus.pending;

  DownloadEntity({
    required this.downloadID,
    required this.url,
    required this.totalLength,
  });

  @override
  List<Object?> get props => [downloadID];

  void updateProgress(DownloadProgressResponse downloadProgressResponse) {
    currentLength += downloadProgressResponse.length;
  }

  factory DownloadEntity.fromEntity(
      DownloadCreatedResponse downloadCreatedResponse) {
    return DownloadEntity(
      downloadID: downloadCreatedResponse.downloadID,
      url: downloadCreatedResponse.url,
      totalLength: downloadCreatedResponse.totalLength,
    );
  }
}

enum DownloadStatus {
  pending,
  ongoing,
  paused,
  manualPaused,
  canceled,
  failed,
  done
}
