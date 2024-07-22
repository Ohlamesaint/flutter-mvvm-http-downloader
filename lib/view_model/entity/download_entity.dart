import 'dart:async';

import '../../shared/api_response.dart';

class DownloadEntity {
  String urlString;
  ApiResponse response;
  int targetLength;
  int currentLength = 0;
  String temporaryAbsolute;
  String filename;
  late StreamSubscription<List<int>> subscription;
  DownloadEntity({
    required this.urlString,
    required this.response,
    required this.targetLength,
    required this.temporaryAbsolute,
    required this.filename,
  });

  set sub(StreamSubscription<List<int>> sub) => subscription = sub;
}
