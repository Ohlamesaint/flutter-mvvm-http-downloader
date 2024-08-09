import 'package:perfect_corp_homework/native/features/download/domain/repository/output/download_progress_response.dart';

class DownloadProgressResponseModel extends DownloadProgressResponse {
  DownloadProgressResponseModel({
    required super.downloadID,
    required super.length,
  });

  factory DownloadProgressResponseModel.fromMap(Map<String, dynamic> data) {
    return DownloadProgressResponseModel(
      downloadID: data['downloadID'],
      length: data['length'],
    );
  }
}
