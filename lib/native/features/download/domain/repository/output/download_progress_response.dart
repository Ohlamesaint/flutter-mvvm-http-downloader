import 'package:equatable/equatable.dart';

class DownloadProgressResponse with EquatableMixin {
  final String downloadID;
  final int length;

  DownloadProgressResponse({required this.downloadID, required this.length});

  factory DownloadProgressResponse.fromJson(Map<String, dynamic> data) {
    return DownloadProgressResponse(
        downloadID: data['downloadID'], length: data['length']);
  }

  @override
  List<Object?> get props => [downloadID];
}
