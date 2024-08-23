import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'download_platform_interface.dart';

/// An implementation of [DownloadPlatform] that uses method channels.
class MethodChannelDownload extends DownloadPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('download');

  final EventChannel _progressEventChannel =
      const EventChannel('http_downloader/download/progress');
  final EventChannel _finishedEventChannel =
      const EventChannel('http_downloader/download/finished');
  final MethodChannel _methodChannel =
      const MethodChannel('http_downloader/download');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>("getPlatformVersion");
    return version;
  }

  @override
  Future<String> createDownload({required String urlString}) async {
    return await _methodChannel.invokeMethod("createDownload", {
      "urlString": urlString,
    });
  }

  @override
  Future<String> cancelDownload({required String downloadID}) async {
    return await _methodChannel.invokeMethod("cancelDownload", {
      "downloadID": downloadID,
    });
  }

  @override
  Future<String> pauseDownload({required String downloadID}) async {
    return await _methodChannel.invokeMethod("pauseDownload", {
      "downloadID": downloadID,
    });
  }

  @override
  Future<String> resumeDownload({required String downloadID}) async {
    return await _methodChannel.invokeMethod("resumeDownload", {
      "downloadID": downloadID,
    });
  }

  @override
  Future<String> manualPauseDownload({required String downloadID}) async {
    return await _methodChannel.invokeMethod("manualPauseDownload", {
      "downloadID": downloadID,
    });
  }

  @override
  Stream getDownloadListStream() {
    return _progressEventChannel.receiveBroadcastStream();
  }

  @override
  Stream getFinishedEventStream() {
    return _finishedEventChannel.receiveBroadcastStream();
  }
}
