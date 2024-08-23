import 'download_platform_interface.dart';

class Download {
  Future<String?> getPlatformVersion() {
    return DownloadPlatform.instance.getPlatformVersion();
  }

  Future<String> createDownload(
      {required String urlString, required bool isConcurrent}) async {
    return await DownloadPlatform.instance
        .createDownload(urlString: urlString, isConcurrent: isConcurrent);
  }

  Future<String> cancelDownload({required String downloadID}) async {
    return await DownloadPlatform.instance
        .cancelDownload(downloadID: downloadID);
  }

  Future<String> pauseDownload({required String downloadID}) async {
    return await DownloadPlatform.instance
        .pauseDownload(downloadID: downloadID);
  }

  Future<String> resumeDownload({required String downloadID}) async {
    return await DownloadPlatform.instance
        .resumeDownload(downloadID: downloadID);
  }

  Future<String> manualPauseDownload({required String downloadID}) async {
    return await DownloadPlatform.instance
        .manualPauseDownload(downloadID: downloadID);
  }

  Stream getDownloadListStream() {
    return DownloadPlatform.instance.getDownloadListStream();
  }

  Stream getFinishedEventStream() {
    return DownloadPlatform.instance.getFinishedEventStream();
  }
}
