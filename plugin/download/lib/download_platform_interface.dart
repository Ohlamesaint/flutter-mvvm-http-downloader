import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'download_method_channel.dart';

abstract class DownloadPlatform extends PlatformInterface {
  /// Constructs a DownloadPlatform.
  DownloadPlatform() : super(token: _token);

  static final Object _token = Object();

  static DownloadPlatform _instance = MethodChannelDownload();

  /// The default instance of [DownloadPlatform] to use.
  ///
  /// Defaults to [MethodChannelDownload].
  static DownloadPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DownloadPlatform] when
  /// they register themselves.
  static set instance(DownloadPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Stream getDownloadListStream();
  Future<String> createDownload(
      {required String urlString, required bool isConcurrent});
  Future<String> pauseDownload({required String downloadID});
  Future<String> resumeDownload({required String downloadID});
  Future<String> cancelDownload({required String downloadID});
  Future<String> manualPauseDownload({required String downloadID});
  // Future<void>> pauseAllDownload();
  // Future<void>> resumeAllDownloadWithoutManualPaused();
  Stream getFinishedEventStream();
}
