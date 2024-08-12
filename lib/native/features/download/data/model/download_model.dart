import 'package:perfect_corp_homework/native/features/download/domain/entity/file_entity.dart';

import '../../domain/entity/download_entity.dart';

class DownloadModel extends DownloadEntity {
  DownloadModel(
      {required super.downloadID,
      required super.url,
      required super.totalLength,
      required super.currentLength,
      required super.status,
      required super.fileEntity});

  // TODO: fromJson, toJson

  factory DownloadModel.fromJson(Map<String, dynamic> json) => DownloadModel(
      downloadID: json['downloadID'],
      url: json['url'],
      totalLength: json['totalLength'],
      currentLength: json['currentLength'],
      status: DownloadStatus.fromJson(json['status']),
      fileEntity: FileEntity.fromJson(json['fileEntity']));
}
