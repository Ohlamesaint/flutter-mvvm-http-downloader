abstract interface class BackendDownloadController {
  String cancelDownload({required String downloadID});

  Future<String> createDownload({required String urlString});

  String pauseDownload({required String downloadID});

  String resumeDownload({required String downloadID});

  String resolveFinishedEvent();

  String resolveDownloadStatusUpdateEvent();
}
