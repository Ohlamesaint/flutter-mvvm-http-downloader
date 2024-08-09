import 'package:equatable/equatable.dart';

class DownloadCreatedResponse with EquatableMixin {
  String downloadID;
  String url;
  int totalLength;

  DownloadCreatedResponse(
      {required this.downloadID, required this.url, required this.totalLength});

  @override
  List<Object?> get props => [downloadID];
}
