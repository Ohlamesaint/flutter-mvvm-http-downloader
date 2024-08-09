import '../../domain/repository/output/download_created_response.dart';

class DownloadCreatedResponseModel extends DownloadCreatedResponse {
  DownloadCreatedResponseModel({
    required super.downloadID,
    required super.url,
    required super.totalLength,
  });

  factory DownloadCreatedResponseModel.fromMap(Map<String, dynamic> data) {
    return DownloadCreatedResponseModel(
      downloadID: data['downloadID'],
      url: data['url'],
      totalLength: data['totalLength'],
    );
  }
}
