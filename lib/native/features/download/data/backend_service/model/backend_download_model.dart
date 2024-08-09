import 'dart:async';

class BackendDownloadModel {
  final String downloadID;
  final String url;
  int totalLength;
  int currentLength = 0;
  final Stream<List<int>> stream;
  late StreamSubscription<List<int>> subscription;

  BackendDownloadModel({
    required this.url,
    required this.downloadID,
    required this.totalLength,
    required this.stream,
  });
}
